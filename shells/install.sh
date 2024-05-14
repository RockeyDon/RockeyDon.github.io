cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/.. || exit 1
git clone https://github.com/theme-keep/hexo-theme-keep-starter
cp ./_config.yml ./hexo-theme-keep-starter/_config.yml
cp -r ./source/ ./hexo-theme-keep-starter/source/
cd ./hexo-theme-keep-starter
npm install
