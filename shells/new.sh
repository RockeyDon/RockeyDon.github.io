cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../hexo-theme-keep-starter || exit 1
hexo new "$1"
