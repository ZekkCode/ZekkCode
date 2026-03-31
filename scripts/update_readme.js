const fs = require('fs');

const GITHUB_API = "https://api.github.com";
const headers = { "User-Agent": "ZekkCode-Readme-Bot" };

async function fetchRepos(endpoint) {
  const response = await fetch(`${GITHUB_API}${endpoint}`, { headers });
  if (!response.ok) throw new Error(`Failed to fetch ${endpoint}: ${response.statusText}`);
  const data = await response.json();
  return data;
}

function formatDate(dateString, isIndo) {
  const monthsEN = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  const monthsID = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
  const d = new Date(dateString);
  const day = String(d.getDate()).padStart(2, '0');
  const month = isIndo ? monthsID[d.getMonth()] : monthsEN[d.getMonth()];
  const year = d.getFullYear();
  return `${day} ${month} ${year}`;
}

function generateMarkdown(repos, isIndo) {
  return repos.map(repo => {
    const createdStr = isIndo ? `🌱 Dibuat: ${formatDate(repo.created_at, true)}` : `🌱 Created: ${formatDate(repo.created_at, false)}`;
    const updatedStr = isIndo ? `🕐 Terakhir update: ${formatDate(repo.pushed_at, true)}` : `🕐 Last commit: ${formatDate(repo.pushed_at, false)}`;
    
    // Removing dashes from names for aesthetic compliance, as requested previously
    const cleanName = repo.name.replace(/-/g, ' ');
    let cleanDesc = repo.description ? repo.description.replace(/-/g, '') : (isIndo ? 'Tidak ada deskripsi' : 'No description provided');
    
    // The user had some manual descriptions override. We will default to github description 
    // but if it's empty, use a graceful fallback. Most of the user's repos have descriptions on Github itself now.
    if (!repo.description && repo.name === 'Bank-TugasProject-Kuliah') {
       cleanDesc = isIndo ? 'Isinya kodingan tugas kuliahku selama di UTM buat arsip pribadi' : 'Collection of my college assignments at UTM for learning purposes';
    }

    return `* <sub>**[${cleanName}](${repo.html_url})** &nbsp; *(${createdStr} | ${updatedStr})*<br>${cleanDesc}</sub>`;
  }).join('\n');
}

async function run() {
  try {
    console.log("Fetching repositories from API...");
    // Fetch user repos and filter out the profile README repo itself
    let zekkCodeRepos = await fetchRepos('/users/ZekkCode/repos?sort=pushed&per_page=15');
    zekkCodeRepos = zekkCodeRepos.filter(r => r.name.toLowerCase() !== 'zekkcode' && r.name.toLowerCase() !== '.github').slice(0, 9);
    
    // Fetch orgs
    let zekkStoreRepos = await fetchRepos('/orgs/zekkstore-dev/repos?sort=pushed');
    let lnkRepos = await fetchRepos('/orgs/Love-Letter-LNK/repos?sort=pushed');
    
    const marks = {
      'ZEKKCODE_EN': generateMarkdown(zekkCodeRepos, false),
      'ZEKKCODE_ID': generateMarkdown(zekkCodeRepos, true),
      'ZEKKSTORE_EN': generateMarkdown(zekkStoreRepos, false),
      'ZEKKSTORE_ID': generateMarkdown(zekkStoreRepos, true),
      'LNK_EN': generateMarkdown(lnkRepos, false),
      'LNK_ID': generateMarkdown(lnkRepos, true)
    };

    let readme = fs.readFileSync('README.md', 'utf-8');

    for (const [key, content] of Object.entries(marks)) {
      const startMarker = `<!-- START_${key} -->`;
      const endMarker = `<!-- END_${key} -->`;
      const regex = new RegExp(`${startMarker}[\\s\\S]*?${endMarker}`, 'g');
      
      const match = readme.match(regex);
      if(match) {
          readme = readme.replace(regex, `${startMarker}\n${content}\n${endMarker}`);
          console.log(`Successfully updated section: ${key}`);
      } else {
          console.log(`Warning: Marker not found for ${key}`);
      }
    }

    fs.writeFileSync('README.md', readme);
    console.log("README.md has been structurally mapped and successfully rewritten!");
  } catch (err) {
    console.error("Failed to build README due to an error.", err);
    process.exit(1);
  }
}

run();
