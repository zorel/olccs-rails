#!/bin/bash
md5=${1}
site=${2}
rails_root=${3}

echo "- Processing : ${site}" >> /tmp/${md5}.debug.log
echo ${1}, ${2}, ${3} >> /tmp/${md5}.debug.log

cd ${rails_root}
mkdir -p public/preview/${md5}
cd public/preview/${md5}
echo $(pwd) >> /tmp/${md5}.debug.log
${rails_root}/vendor/phantomjs/bin/phantomjs ${rails_root}/script/preview.js ${site} &> /tmp/${md5}.debug.log
convert "site.png" -crop 1024x768+0+0 "site.png"
convert "site.png" -filter Lanczos -thumbnail 200x150 "site-thumbnail.png"
echo "- Done processing : ${site}" >> /tmp/${md5}.debug.log
