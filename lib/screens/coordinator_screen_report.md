# COORDINATOR SCREEN REPORT

<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Excelerate Global - Attendance Reports</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
          darkMode: "class",
          theme: {
            extend: {
              "colors": {
                      "primary-fixed-dim": "#b4c5ff",
                      "inverse-surface": "#293040",
                      "primary-container": "#2563eb",
                      "surface-container-lowest": "#ffffff",
                      "secondary-fixed-dim": "#b7c8e1",
                      "on-surface-variant": "#434655",
                      "surface-container-highest": "#dce2f7",
                      "inverse-on-surface": "#edf0ff",
                      "on-primary-fixed": "#00174b",
                      "inverse-primary": "#b4c5ff",
                      "surface-container-high": "#e1e8fd",
                      "tertiary-fixed": "#e0e3e5",
                      "secondary": "#505f76",
                      "primary-fixed": "#dbe1ff",
                      "on-secondary-fixed-variant": "#38485d",
                      "tertiary-fixed-dim": "#c4c7c9",
                      "on-primary-fixed-variant": "#003ea8",
                      "on-primary-container": "#eeefff",
                      "on-tertiary": "#ffffff",
                      "surface-bright": "#f9f9ff",
                      "on-surface": "#141b2b",
                      "surface-container": "#e9edff",
                      "secondary-fixed": "#d3e4fe",
                      "surface-variant": "#dce2f7",
                      "surface": "#f9f9ff",
                      "on-background": "#141b2b",
                      "surface-tint": "#0053db",
                      "surface-container-low": "#f1f3ff",
                      "on-tertiary-fixed": "#191c1e",
                      "on-secondary": "#ffffff",
                      "on-primary": "#ffffff",
                      "error": "#ba1a1a",
                      "on-secondary-container": "#54647a",
                      "primary": "#004ac6",
                      "tertiary-container": "#6b6e70",
                      "surface-dim": "#d3daef",
                      "on-secondary-fixed": "#0b1c30",
                      "on-error": "#ffffff",
                      "outline": "#737686",
                      "background": "#f9f9ff",
                      "error-container": "#ffdad6",
                      "tertiary": "#525657",
                      "secondary-container": "#d0e1fb",
                      "outline-variant": "#c3c6d7",
                      "on-tertiary-container": "#eff1f3",
                      "on-tertiary-fixed-variant": "#444749",
                      "on-error-container": "#93000a"
              },
              "borderRadius": {
                      "DEFAULT": "0.25rem",
                      "lg": "0.5rem",
                      "xl": "0.75rem",
                      "full": "9999px"
              },
              "spacing": {
                      "margin-mobile": "16px",
                      "lg": "24px",
                      "md": "16px",
                      "sm": "8px",
                      "gutter-mobile": "12px",
                      "xs": "4px",
                      "base": "4px",
                      "xl": "32px",
                      "bottom-nav": "80px"
              },
              "fontFamily": {
                      "title-lg": [
                              "Inter"
                      ],
                      "headline-lg-mobile": [
                              "Inter"
                      ],
                      "headline-lg": [
                              "Inter"
                      ],
                      "label-md": [
                              "Inter"
                      ],
                      "body-lg": [
                              "Inter"
                      ],
                      "body-md": [
                              "Inter"
                      ],
                      "headline-md": [
                              "Inter"
                      ],
                      "display-sm": [
                              "Inter"
                      ]
              },
              "fontSize": {
                      "title-lg": [
                              "18px",
                              {
                                      "lineHeight": "26px",
                                      "fontWeight": "600"
                              }
                      ],
                      "headline-lg-mobile": [
                              "22px",
                              {
                                      "lineHeight": "28px",
                                      "fontWeight": "600"
                              }
                      ],
                      "headline-lg": [
                              "24px",
                              {
                                      "lineHeight": "32px",
                                      "letterSpacing": "-0.01em",
                                      "fontWeight": "600"
                              }
                      ],
                      "label-md": [
                              "12px",
                              {
                                      "lineHeight": "16px",
                                      "letterSpacing": "0.05em",
                                      "fontWeight": "500"
                              }
                      ],
                      "body-lg": [
                              "16px",
                              {
                                      "lineHeight": "24px",
                                      "fontWeight": "400"
                              }
                      ],
                      "body-md": [
                              "14px",
                              {
                                      "lineHeight": "20px",
                                      "fontWeight": "400"
                              }
                      ],
                      "headline-md": [
                              "20px",
                              {
                                      "lineHeight": "28px",
                                      "fontWeight": "600"
                              }
                      ],
                      "display-sm": [
                              "30px",
                              {
                                      "lineHeight": "38px",
                                      "letterSpacing": "-0.02em",
                                      "fontWeight": "700"
                              }
                      ]
              }
      },
          },
        }
      </script>
<style>
        .material-symbols-outlined {
          font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body {
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
</head>
<body class="bg-surface text-on-surface min-h-screen pb-bottom-nav md:pb-0 md:pt-16">
<!-- TopAppBar (Mobile: hidden, Desktop: fixed top) -->
<header class="fixed top-0 w-full z-50 border-b border-outline-variant bg-surface hidden md:flex justify-between items-center px-margin-mobile h-16 transition-colors duration-200 flat no shadows">
<div class="flex items-center gap-md">
<span class="font-headline-md text-headline-md font-bold text-primary">Excelerate Global</span>
</div>
<nav class="flex gap-lg">
<a class="font-label-md text-label-md text-on-surface-variant hover:bg-surface-container-low transition-colors duration-200 px-sm py-xs rounded flex items-center gap-xs" href="#">
<span class="material-symbols-outlined text-[18px]">dashboard</span> Dashboard
             </a>
<a class="font-label-md text-label-md text-primary font-bold hover:bg-surface-container-low transition-colors duration-200 px-sm py-xs rounded flex items-center gap-xs" href="#">
<span class="material-symbols-outlined text-[18px]" style="font-variation-settings: 'FILL' 1;">assessment</span> Reports
             </a>
<a class="font-label-md text-label-md text-on-surface-variant hover:bg-surface-container-low transition-colors duration-200 px-sm py-xs rounded flex items-center gap-xs" href="#">
<span class="material-symbols-outlined text-[18px]">person</span> Profile
             </a>
</nav>
<div class="flex items-center gap-md">
<button class="text-on-surface-variant hover:bg-surface-container-low p-sm rounded-full transition-colors duration-200">
<span class="material-symbols-outlined" data-icon="notifications">notifications</span>
</button>
<div class="w-8 h-8 rounded-full overflow-hidden border border-outline-variant">
<img alt="User Profile Avatar" class="w-full h-full object-cover" data-alt="A professional headshot of a corporate manager in a bright, modern office setting. The lighting is soft and even, reflecting a clean, minimalist corporate aesthetic." src="https://lh3.googleusercontent.com/aida-public/AB6AXuBqWvslyYR2tGb3N041bU2-sPUyB6INm9IvTkLs4EBXugb-6bpYGTu-A0AWFkKd7BWEEpc4iqR0NMhJY1anILnvXJE1PXfFX8UDJSSwu3dQdYAIDLj_pv32rdQ-twaf7RtSi-ACyu8jA4qxpcSp_7ElSUofLQdGgFFUxIBeHIogymtycR9arurrPryeMZ4D3QH9nI5hgO42Bv8GETuBcUfF2FE5csuEX-NTO28vtiXxzdHtTPU9eR2o0HX0GllvFJCB4fVohq_iWFLt"/>
</div>
</div>
</header>
<!-- TopAppBar Mobile Standin -->
<header class="fixed top-0 w-full z-50 border-b border-outline-variant bg-surface md:hidden flex justify-between items-center px-margin-mobile h-16 transition-colors duration-200 flat no shadows">
<span class="font-headline-md text-headline-md font-bold text-primary">Excelerate Global</span>
<div class="flex items-center gap-sm">
<button class="text-on-surface-variant hover:bg-surface-container-low p-sm rounded-full transition-colors duration-200">
<span class="material-symbols-outlined" data-icon="notifications">notifications</span>
</button>
<div class="w-8 h-8 rounded-full overflow-hidden border border-outline-variant">
<img alt="User Profile Avatar" class="w-full h-full object-cover" data-alt="A professional headshot of a corporate manager in a bright, modern office setting. The lighting is soft and even, reflecting a clean, minimalist corporate aesthetic." src="https://lh3.googleusercontent.com/aida-public/AB6AXuAECSW5tRB7_dj3IVAdLNhrvRYypr1dtx7-i8j51oKjiE3HhglgydFij5OlLWR48bx3A26RjoQ40lodbeOjAwdsor4SX2iIF_LXP_CUyRnTDwsvjpW1d8n_M3_-eoU1RVKQVTvYW2MbgZWLk0t3ct5sDcWp_Nr-QSep-GrZ7VejkaeM_6otGKil5l6iP8UNp0j6nDQ1lqFAjBC2gaQnYgM1yN-7Cp2jVx0j0FfS7P3Xd88A-YtglS2GorIuyxSxcVq2f9sHAHH_jBR1"/>
</div>
</div>
</header>
<main class="max-w-7xl mx-auto px-margin-mobile pt-20 md:pt-lg pb-xl">
<!-- Page Header -->
<div class="mb-lg flex flex-col md:flex-row md:items-end justify-between gap-md">
<div>
<h1 class="font-headline-lg-mobile text-headline-lg-mobile md:font-headline-lg md:text-headline-lg text-on-surface">Attendance Reports</h1>
<p class="font-body-md text-body-md text-on-surface-variant mt-xs">Overview of intern participation and historical data.</p>
</div>
<!-- Search -->
<div class="relative w-full md:w-80">
<span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline">search</span>
<input class="w-full pl-xl pr-sm py-sm rounded-lg border border-outline-variant bg-surface-container-lowest font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-shadow" placeholder="Search interns..." type="text"/>
</div>
</div><div class="flex gap-sm mb-lg overflow-x-auto pb-xs">
<button class="px-md py-xs bg-primary text-on-primary rounded-full font-label-md text-label-md whitespace-nowrap">All</button>
<button class="px-md py-xs bg-surface-container-high text-on-surface-variant hover:bg-surface-variant rounded-full font-label-md text-label-md whitespace-nowrap transition-colors">Engineering</button>
<button class="px-md py-xs bg-surface-container-high text-on-surface-variant hover:bg-surface-variant rounded-full font-label-md text-label-md whitespace-nowrap transition-colors">Design</button>
<button class="px-md py-xs bg-surface-container-high text-on-surface-variant hover:bg-surface-variant rounded-full font-label-md text-label-md whitespace-nowrap transition-colors">Marketing</button>
</div>
<!-- Analytics Bento Grid -->
<div class="grid grid-cols-1 md:grid-cols-3 gap-md mb-xl">
<div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-[0px_4px_12px_rgba(0,0,0,0.05)] flex items-center justify-between">
<div>
<p class="font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Average Attendance</p>
<p class="font-display-sm text-display-sm text-primary mt-xs">88%</p>
</div>
<div class="w-12 h-12 rounded-full bg-surface-container flex items-center justify-center text-primary">
<span class="material-symbols-outlined text-[24px]">monitoring</span>
</div>
</div>
<div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-[0px_4px_12px_rgba(0,0,0,0.05)] flex items-center justify-between">
<div>
<p class="font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Total Sessions</p>
<p class="font-display-sm text-display-sm text-on-surface mt-xs">45</p>
</div>
<div class="w-12 h-12 rounded-full bg-surface-container flex items-center justify-center text-primary">
<span class="material-symbols-outlined text-[24px]">calendar_today</span>
</div>
</div>
<div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-[0px_4px_12px_rgba(0,0,0,0.05)] flex items-center justify-between">
<div>
<p class="font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Active Interns</p>
<p class="font-display-sm text-display-sm text-on-surface mt-xs">150</p>
</div>
<div class="w-12 h-12 rounded-full bg-surface-container flex items-center justify-center text-primary">
<span class="material-symbols-outlined text-[24px]">person</span>
</div>
</div>
</div><div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md mb-xl shadow-[0px_4px_12px_rgba(0,0,0,0.05)]">
<div class="flex items-center justify-between mb-md">
<h2 class="font-title-lg text-title-lg text-on-surface">Monthly Participation Trend</h2>
<span class="material-symbols-outlined text-on-surface-variant">more_vert</span>
</div>
<div class="h-48 w-full bg-surface-container-low rounded-lg flex items-end justify-around p-sm gap-xs">
<div class="w-full bg-primary/20 rounded-t h-[60%] relative group"><div class="absolute -top-6 left-1/2 -translate-x-1/2 bg-inverse-surface text-inverse-on-surface text-[10px] px-xs py-[2px] rounded opacity-0 group-hover:opacity-100 transition-opacity">82%</div></div>
<div class="w-full bg-primary/40 rounded-t h-[75%] relative group"><div class="absolute -top-6 left-1/2 -translate-x-1/2 bg-inverse-surface text-inverse-on-surface text-[10px] px-xs py-[2px] rounded opacity-0 group-hover:opacity-100 transition-opacity">85%</div></div>
<div class="w-full bg-primary/60 rounded-t h-[88%] relative group"><div class="absolute -top-6 left-1/2 -translate-x-1/2 bg-inverse-surface text-inverse-on-surface text-[10px] px-xs py-[2px] rounded opacity-0 group-hover:opacity-100 transition-opacity">88%</div></div>
<div class="w-full bg-primary rounded-t h-[92%] relative group"><div class="absolute -top-6 left-1/2 -translate-x-1/2 bg-inverse-surface text-inverse-on-surface text-[10px] px-xs py-[2px] rounded opacity-0 group-hover:opacity-100 transition-opacity">92%</div></div>
</div>
<div class="flex justify-around mt-xs text-label-md text-on-surface-variant">
<span>Sep</span><span>Oct</span><span>Nov</span><span>Dec</span>
</div>
</div>
<!-- Attendance History Table -->
<div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-[0px_4px_12px_rgba(0,0,0,0.05)] overflow-hidden">
<div class="p-md border-b border-outline-variant bg-surface-bright">
<h2 class="font-title-lg text-title-lg text-on-surface">Attendance History</h2>
</div>
<div class="overflow-x-auto">
<table class="w-full text-left border-collapse">
<thead>
<tr class="border-b border-outline-variant bg-surface-container-lowest">
<th class="px-md py-sm font-label-md text-label-md text-on-surface-variant uppercase tracking-wider whitespace-nowrap">Intern Name</th>
<th class="px-md py-sm font-label-md text-label-md text-on-surface-variant uppercase tracking-wider whitespace-nowrap text-right">Present Count</th><th class="px-md py-sm font-label-md text-label-md text-on-surface-variant uppercase tracking-wider whitespace-nowrap text-center">Status</th>
<th class="px-md py-sm font-label-md text-label-md text-on-surface-variant uppercase tracking-wider whitespace-nowrap text-right">Absent Count</th>
<th class="px-md py-sm font-label-md text-label-md text-on-surface-variant uppercase tracking-wider whitespace-nowrap text-right">Participation %</th>
</tr>
</thead>
<tbody class="font-body-md text-body-md">
<!-- Row 1 -->
<tr class="border-b border-outline-variant hover:bg-surface-container-low transition-colors">
<td class="px-md py-sm flex items-center gap-sm whitespace-nowrap">
<div class="w-8 h-8 rounded-full overflow-hidden border border-outline-variant bg-surface-variant shrink-0">
<img alt="Sarah Jenkins" class="w-full h-full object-cover" data-alt="A small profile headshot of a young professional woman smiling slightly, against a neutral white background, well-lit and corporate." src="https://lh3.googleusercontent.com/aida-public/AB6AXuA1DlCD4H6DRt-QafkOy9G7rImtcILFBBcqmGfXzG4Rm22A-3XA3EHUAYXGMQ42O7JJKMjXHy9OpbRo6Yx3Uolkd1IIW0f4wXXtUgFUD6ArJmrgNCN3XjjMyp7wrwzF1l7l6syuoCWLS4YzHoUWoAsaMsFwdZSkImRUISBnlwL3_ZHNhmTHSIHom629H_Za5An3IHxq75IpyCJKU27FX-jcEydl3NYIPcoK5xwl67SMjKRHAVjiX5Crbc0_sDR-rzwrtjr8erzEt_q0"/>
</div>
<span class="text-on-surface font-medium">Sarah Jenkins</span>
</td>
<td class="px-md py-sm text-right text-on-surface">42</td><td class="px-md py-sm text-center">
<span class="px-sm py-xs bg-green-100 text-green-800 rounded-full text-[10px] font-bold uppercase tracking-tight">On Track</span>
</td>
<td class="px-md py-sm text-right text-on-surface-variant">3</td>
<td class="px-md py-sm text-right text-primary font-medium">93%</td>
</tr>
<!-- Row 2 -->
<tr class="border-b border-outline-variant hover:bg-surface-container-low transition-colors">
<td class="px-md py-sm flex items-center gap-sm whitespace-nowrap">
<div class="w-8 h-8 rounded-full overflow-hidden border border-outline-variant bg-surface-variant shrink-0">
<span class="material-symbols-outlined text-outline-variant w-full h-full flex items-center justify-center text-[20px]">person</span>
</div>
<span class="text-on-surface font-medium">Michael Chen</span>
</td>
<td class="px-md py-sm text-right text-on-surface">38</td><td class="px-md py-sm text-center">
<span class="px-sm py-xs bg-yellow-100 text-yellow-800 rounded-full text-[10px] font-bold uppercase tracking-tight">Needs Review</span>
</td>
<td class="px-md py-sm text-right text-on-surface-variant">7</td>
<td class="px-md py-sm text-right text-primary font-medium">84%</td>
</tr>
<!-- Row 3 -->
<tr class="border-b border-outline-variant hover:bg-surface-container-low transition-colors">
<td class="px-md py-sm flex items-center gap-sm whitespace-nowrap">
<div class="w-8 h-8 rounded-full overflow-hidden border border-outline-variant bg-surface-variant shrink-0">
<img alt="David Miller" class="w-full h-full object-cover" data-alt="A small profile headshot of a young professional man with glasses, neutral expression, neutral white background, well-lit." src="https://lh3.googleusercontent.com/aida-public/AB6AXuB14agKvc2F6GKeX7SfjTOjyBUgVGhuohPYkv94dpmt3aGxItpdMDEeg1CRcqDBvi_tXXg7k8mxsG2dYUoXjQneZ8Fd-gr5L60MsNvo7YN1cRVLZHRSa_0WuPj10i7dqxfsrL1Of45U9inR-dPF8PCtZaBZm843AAppd1WT7wKr_fSiJ_8OeZIPxG00JCreGzK99qnyJLKbidj1xmcx1pJqslarVh6_sP4fosLsgdFOQr5TqixxBrRMhvnJGo0Rb0QVgr_j7qS-9b7z"/>
</div>
<span class="text-on-surface font-medium">David Miller</span>
</td>
<td class="px-md py-sm text-right text-on-surface">45</td><td class="px-md py-sm text-center">
<span class="px-sm py-xs bg-green-100 text-green-800 rounded-full text-[10px] font-bold uppercase tracking-tight">On Track</span>
</td>
<td class="px-md py-sm text-right text-on-surface-variant">0</td>
<td class="px-md py-sm text-right text-primary font-medium">100%</td>
</tr>
<!-- Row 4 -->
<tr class="border-b border-outline-variant hover:bg-surface-container-low transition-colors">
<td class="px-md py-sm flex items-center gap-sm whitespace-nowrap">
<div class="w-8 h-8 rounded-full overflow-hidden border border-outline-variant bg-surface-variant shrink-0">
<span class="material-symbols-outlined text-outline-variant w-full h-full flex items-center justify-center text-[20px]">person</span>
</div>
<span class="text-on-surface font-medium">Elena Rodriguez</span>
</td>
<td class="px-md py-sm text-right text-on-surface">35</td><td class="px-md py-sm text-center">
<span class="px-sm py-xs bg-red-100 text-red-800 rounded-full text-[10px] font-bold uppercase tracking-tight">At Risk</span>
</td>
<td class="px-md py-sm text-right text-on-surface-variant">10</td>
<td class="px-md py-sm text-right text-[#991B1B] font-medium">77%</td>
</tr>
</tbody>
</table>
</div>
<div class="p-sm flex justify-center border-t border-outline-variant bg-surface-container-lowest">
<button class="px-md py-sm text-primary font-label-md text-label-md hover:bg-surface-container-low rounded transition-colors">View All Interns</button>
</div>
</div>
</main>
<!-- BottomNavBar (Mobile only) -->
<nav class="fixed bottom-0 w-full z-50 shadow-[0px_-4px_12px_rgba(0,0,0,0.05)] bg-surface shadow-lg md:hidden flex justify-around items-center h-bottom-nav px-gutter-mobile pb-safe transition-colors duration-200">
<a class="flex flex-col items-center justify-center text-on-secondary-container hover:bg-secondary-container transition-all active:scale-95 p-sm rounded-lg min-w-[64px]" href="#">
<span class="material-symbols-outlined mb-xs" data-icon="dashboard">dashboard</span>
<span class="font-label-md text-label-md">Dashboard</span>
</a>
<a class="flex flex-col items-center justify-center text-primary font-bold hover:bg-secondary-container transition-all active:scale-95 p-sm rounded-lg min-w-[64px]" href="#">
<span class="material-symbols-outlined mb-xs" data-icon="assessment" data-weight="fill" style="font-variation-settings: 'FILL' 1;">assessment</span>
<span class="font-label-md text-label-md">Reports</span>
</a>
<a class="flex flex-col items-center justify-center text-on-secondary-container hover:bg-secondary-container transition-all active:scale-95 p-sm rounded-lg min-w-[64px]" href="#">
<span class="material-symbols-outlined mb-xs" data-icon="person">person</span>
<span class="font-label-md text-label-md">Profile</span>
</a>
</nav>
</body></html>