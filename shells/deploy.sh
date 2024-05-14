cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../hexo-theme-keep-starter || exit 1 
# 清除缓存
hexo clean
# 生成文件
hexo generate
# 移动文件
cp -r ./public/* ../docs
cp ./_config.yml ../_config.yml
cp -r ./source/ ../source/
# 手动提交
cd ../
git add .
git commit --amend -m "Add Hexo static files to doc folder"
git push --force origin main
