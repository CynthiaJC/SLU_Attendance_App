import json
import os
import re
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import parse_qs, urlparse

DATA_FILE = os.path.join(os.path.dirname(__file__), 'assets', 'sample_data.json')

def load_data():
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r', encoding='utf-8') as f:
            return json.load(f)
    return {"summary": {}, "interns": [], "meetings": [], "attendanceRecords": []}

def save_data(data):
    with open(DATA_FILE, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)

class MockAPIHandler(BaseHTTPRequestHandler):
    def _send_json(self, data, status_code=200):
        self.send_response(status_code)
        self.send_header('Content-Type', 'application/json; charset=utf-8')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, DELETE')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
        self.wfile.write(json.dumps(data, indent=2).encode('utf-8'))

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, DELETE')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

    def do_GET(self):
        parsed = urlparse(self.path)
        path = parsed.path
        query = parse_qs(parsed.query)
        data = load_data()

        # Root / Health Check
        if path == '/' or path == '/api':
            self._send_json({
                "message": "SLU Attendance App Mock API",
                "endpoints": [
                    "/api/summary",
                    "/api/interns",
                    "/api/interns/<id>",
                    "/api/meetings",
                    "/api/meetings/<id>",
                    "/api/attendance",
                    "/api/attendance/<id>"
                ]
            })
            return

        # Summary endpoint
        if path == '/api/summary':
            self._send_json(data.get("summary", {}))
            return

        # Interns endpoint
        if path == '/api/interns':
            interns = data.get("interns", [])
            # Filter by department
            dept = query.get('department', [None])[0]
            if dept and dept.lower() != 'all':
                interns = [i for i in interns if i.get('department', '').lower() == dept.lower()]
            # Filter by status
            status = query.get('status', [None])[0]
            if status and status.lower() != 'all':
                interns = [i for i in interns if i.get('status', '').lower() == status.lower()]
            # Search query
            q = query.get('search', [None])[0]
            if q:
                interns = [i for i in interns if q.lower() in i.get('name', '').lower() or q.lower() in i.get('studentId', '').lower()]
            self._send_json(interns)
            return

        intern_match = re.match(r'^/api/interns/([^/]+)$', path)
        if intern_match:
            intern_id = intern_match.group(1)
            intern = next((i for i in data.get("interns", []) if i.get('id') == intern_id), None)
            if intern:
                self._send_json(intern)
            else:
                self._send_json({"error": "Intern not found"}, status_code=404)
            return

        # Meetings endpoint
        if path == '/api/meetings':
            meetings = data.get("meetings", [])
            type_filter = query.get('type', [None])[0]
            if type_filter and type_filter.lower() != 'all':
                meetings = [m for m in meetings if m.get('type', '').lower() == type_filter.lower()]
            dept = query.get('department', [None])[0]
            if dept and dept.lower() != 'all':
                meetings = [m for m in meetings if m.get('department', '').lower() in [dept.lower(), 'all']]
            self._send_json(meetings)
            return

        meeting_match = re.match(r'^/api/meetings/([^/]+)$', path)
        if meeting_match:
            meeting_id = meeting_match.group(1)
            meeting = next((m for m in data.get("meetings", []) if m.get('id') == meeting_id), None)
            if meeting:
                self._send_json(meeting)
            else:
                self._send_json({"error": "Meeting not found"}, status_code=404)
            return

        # Attendance endpoint
        if path == '/api/attendance':
            records = data.get("attendanceRecords", [])
            intern_id = query.get('internId', [None])[0]
            if intern_id:
                records = [r for r in records if r.get('internId') == intern_id]
            meeting_id = query.get('meetingId', [None])[0]
            if meeting_id:
                records = [r for r in records if r.get('meetingId') == meeting_id]
            status = query.get('status', [None])[0]
            if status:
                records = [r for r in records if r.get('status', '').lower() == status.lower()]
            self._send_json(records)
            return

        self._send_json({"error": "Endpoint not found"}, status_code=404)

    def do_POST(self):
        parsed = urlparse(self.path)
        path = parsed.path
        content_length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(content_length)
        payload = json.loads(body) if body else {}

        data = load_data()

        if path == '/api/attendance':
            new_id = f"ATT-{1000 + len(data.get('attendanceRecords', [])) + 1}"
            new_record = {
                "id": new_id,
                "internId": payload.get("internId", ""),
                "internName": payload.get("internName", ""),
                "meetingId": payload.get("meetingId", ""),
                "meetingTitle": payload.get("meetingTitle", ""),
                "date": payload.get("date", "2026-07-25"),
                "timeIn": payload.get("timeIn", "09:00 AM"),
                "timeOut": payload.get("timeOut", "10:30 AM"),
                "status": payload.get("status", "Present"),
                "checkInMethod": payload.get("checkInMethod", "QR Code"),
                "notes": payload.get("notes", "New check-in record")
            }
            data["attendanceRecords"].append(new_record)
            save_data(data)
            self._send_json(new_record, status_code=201)
            return

        self._send_json({"error": "Endpoint not found"}, status_code=404)

def run(port=8080):
    server_address = ('', port)
    httpd = HTTPServer(server_address, MockAPIHandler)
    print(f"SLU Attendance Mock API running at http://localhost:{port}/api")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")

if __name__ == '__main__':
    run(8080)
