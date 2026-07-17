param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$owner = "ZekkCode"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI (gh) belum terpasang. Install dari https://cli.github.com lalu jalankan: gh auth login"
}

gh auth status | Out-Null

$repositories = @(
    [pscustomobject]@{ Name = "ZekkCode"; Description = "Profile Repository • Personal GitHub profile showcasing selected projects, skills, and professional interests."; Topics = @("github-profile", "portfolio", "ui-ux", "frontend", "informatics") },
    [pscustomobject]@{ Name = "AboutMeZekk"; Description = "Profile Experiment • Simple personal introduction and GitHub profile experiment."; Topics = @("profile", "personal-website", "learning-project") },
    [pscustomobject]@{ Name = "Portofolio_Web"; Description = "Portfolio Project • Personal portfolio website showcasing UI/UX, graphic design, and frontend development work."; Topics = @("portfolio", "ui-ux", "graphic-design", "frontend", "personal-website") },

    [pscustomobject]@{ Name = "OnlineTest-TOEFL_DPW"; Description = "Academic Team Project • Responsive TOEFL simulation platform with scoring, dashboard, leaderboard, and digital certificates."; Topics = @("academic-project", "toefl", "ui-ux", "frontend", "javascript", "education") },
    [pscustomobject]@{ Name = "Pendata"; Description = "Academic Project • Data mining and machine learning analysis of higher education student performance."; Topics = @("academic-project", "data-mining", "machine-learning", "python", "jupyter-book", "student-performance") },
    [pscustomobject]@{ Name = "cehati-web-search-engine"; Description = "Academic Project • Hybrid medical search engine combining BM25 and semantic retrieval for Indonesian health articles."; Topics = @("academic-project", "information-retrieval", "search-engine", "bm25", "semantic-search", "nextjs", "huggingface") },
    [pscustomobject]@{ Name = "information-retrieval"; Description = "Academic Repository • Coursework and experiments covering information retrieval concepts and search systems."; Topics = @("academic-project", "information-retrieval", "search-engine", "coursework") },
    [pscustomobject]@{ Name = "2025-2026_Gasal_PAW_B"; Description = "Academic Repository • Web Application Programming coursework, exercises, and semester assignments."; Topics = @("academic-project", "web-programming", "coursework", "php", "javascript") },
    [pscustomobject]@{ Name = "PAW-P12_CRUD"; Description = "Academic Practice • CRUD web application developed for Web Application Programming coursework."; Topics = @("academic-project", "crud", "web-programming", "php", "database") },
    [pscustomobject]@{ Name = "To-Do-Kampus-PAW"; Description = "Academic Practice • Campus task management web application created for Web Application Programming."; Topics = @("academic-project", "todo-app", "web-programming", "frontend") },
    [pscustomobject]@{ Name = "MathDiskret"; Description = "Academic Project • Discrete mathematics learning project with interactive educational materials."; Topics = @("academic-project", "discrete-mathematics", "education", "learning") },
    [pscustomobject]@{ Name = "Bank-TugasProject-Kuliah"; Description = "Academic Archive • Collection of coursework and programming projects from Informatics Engineering."; Topics = @("academic-archive", "coursework", "informatics", "student-projects") },

    [pscustomobject]@{ Name = "trevio-project"; Description = "Collaborative Project • Hotel booking system built with custom PHP MVC, MySQL, and Tailwind CSS."; Topics = @("collaborative-project", "hotel-booking", "php", "mysql", "tailwindcss", "mvc", "ui-ux") },
    [pscustomobject]@{ Name = "Web_Angkatan2024"; Description = "Community Project • Informatics Engineering 2024 cohort website for shared information and community identity."; Topics = @("community-project", "informatics", "student-community", "frontend", "website") },
    [pscustomobject]@{ Name = "WebGarden-LiaAka"; Description = "Personal Project • Interactive digital memory website with gallery, stories, and private keepsakes."; Topics = @("personal-project", "interactive-website", "gallery", "frontend") },

    [pscustomobject]@{ Name = "JuaraVibeCoding-2026-BedahCV"; Description = "Competition Project • AI-powered CV analyzer with ATS feedback and STAR-based improvement suggestions."; Topics = @("competition-project", "ai", "cv-analyzer", "ats", "gemini", "nextjs", "google-cloud") },
    [pscustomobject]@{ Name = "SIGAP-Pangan"; Description = "Innovation Project • AI-powered food supply monitoring, forecasting, risk mapping, and alert platform."; Topics = @("innovation-project", "artificial-intelligence", "forecasting", "food-supply", "nextjs", "nestjs", "azure") },

    [pscustomobject]@{ Name = "zervis-md-media-downloader"; Description = "Independent Project • Telegram media automation bot with FastAPI dashboard and Docker deployment."; Topics = @("independent-project", "telegram-bot", "fastapi", "python", "docker", "media-downloader") },
    [pscustomobject]@{ Name = "ZEDD-Zekk-External-Downloader-Drive"; Description = "Independent Project • External media downloader with cloud storage and Google Drive integration."; Topics = @("independent-project", "media-downloader", "google-drive", "cloud-storage", "web-application") },
    [pscustomobject]@{ Name = "9router"; Description = "Independent Project • Local AI model router and OpenAI-compatible gateway for development workflows."; Topics = @("independent-project", "ai-router", "openai-compatible", "local-ai", "developer-tools") },
    [pscustomobject]@{ Name = "BlogZekkTech"; Description = "Independent Project • Technology blog platform for publishing coding, web development, and learning articles."; Topics = @("independent-project", "technology-blog", "laravel", "web-development", "articles") },
    [pscustomobject]@{ Name = "ZekkTechWordpress"; Description = "Independent Project • Custom WordPress themes and plugins developed for the ZekkTech blog."; Topics = @("independent-project", "wordpress", "themes", "plugins", "web-development") },
    [pscustomobject]@{ Name = "BotZekkStoreTelegram"; Description = "Independent Project • Telegram bot for browsing and purchasing digital products."; Topics = @("independent-project", "telegram-bot", "digital-products", "automation") },
    [pscustomobject]@{ Name = "Download-Video-Lewat-Network-Capture"; Description = "Learning Resource • Guide and Python workflow for downloading HLS media discovered through browser network capture."; Topics = @("learning-resource", "python", "hls", "network-capture", "media-downloader") },

    [pscustomobject]@{ Name = "P04-Form-Array-Looping-Branching"; Description = "Learning Repository • Web programming practice covering forms, arrays, loops, and conditional branching."; Topics = @("learning-repository", "web-programming", "arrays", "loops", "branching") },
    [pscustomobject]@{ Name = "TutorialMathDiskret"; Description = "Learning Resource • Discrete mathematics tutorials and supporting educational materials."; Topics = @("learning-resource", "discrete-mathematics", "tutorial", "education") },
    [pscustomobject]@{ Name = "School-Page-Project"; Description = "Learning Project • Simple school landing page developed to practice frontend fundamentals."; Topics = @("learning-project", "landing-page", "frontend", "html", "css") },
    [pscustomobject]@{ Name = "skills-introduction-to-git"; Description = "Learning Repository • GitHub Skills course covering Git and collaborative development fundamentals."; Topics = @("learning-repository", "github-skills", "git", "collaboration") },
    [pscustomobject]@{ Name = "skills-introduction-to-codeql"; Description = "Learning Repository • GitHub Skills course exploring CodeQL and code security analysis."; Topics = @("learning-repository", "github-skills", "codeql", "security") },
    [pscustomobject]@{ Name = "skills-communicate-using-markdown"; Description = "Learning Repository • GitHub Skills course for writing and communicating effectively with Markdown."; Topics = @("learning-repository", "github-skills", "markdown", "documentation") },

    [pscustomobject]@{ Name = "Bank-Freelance_ZekkStore"; Description = "Freelance Archive • Repository reserved for selected freelance work and project documentation."; Topics = @("freelance-archive", "client-projects", "documentation") },
    [pscustomobject]@{ Name = "freeakun"; Description = "Archived Repository • Previous experimental project retained for personal reference."; Topics = @("archived-project", "experiment", "reference") }
)

$success = 0
$failed = 0

foreach ($item in $repositories) {
    $repo = "$owner/$($item.Name)"
    Write-Host "`nUpdating $repo" -ForegroundColor Cyan
    Write-Host "Description: $($item.Description)"
    Write-Host "Topics: $($item.Topics -join ', ')"

    if ($DryRun) {
        continue
    }

    try {
        gh repo edit $repo --description $item.Description

        $payload = @{ names = $item.Topics } | ConvertTo-Json -Compress
        $payload | gh api --method PUT `
            -H "Accept: application/vnd.github+json" `
            -H "X-GitHub-Api-Version: 2022-11-28" `
            "repos/$repo/topics" --input - | Out-Null

        Write-Host "Success" -ForegroundColor Green
        $success++
    }
    catch {
        Write-Warning "Failed: $repo - $($_.Exception.Message)"
        $failed++
    }
}

Write-Host "`nFinished. Success: $success | Failed: $failed" -ForegroundColor Yellow

if ($DryRun) {
    Write-Host "Dry run only. No repository metadata was changed." -ForegroundColor Yellow
}
