#!/bin/sh

set -e

# setup ssh-private-key
mkdir -p /root/.ssh/
echo "$INPUT_DEPLOY_KEY" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
ssh-keyscan -t rsa e.coding.net >> /root/.ssh/known_hosts

# setup deploy git account
git config --global user.name "$INPUT_USER_NAME"
git config --global user.email "$INPUT_USER_EMAIL"

# install hexo env
pwd
node -v
npx hexo -v
npm ls hexo-deployer-git
# npm ls hexo-algolia
#npm install hexo-cli -g
#npm install hexo-deployer-git --save
#npm install hexo-algolia --save

# deployment
# pwd
# cd /home/runner/work/HexoBlog/HexoBlog
pwd
ls -a
git clone https://github.com/deppwang/deppwang.github.io.git .deploy_git
ls -a
rm -rf node_modules && npm install --force
npx hexo g -d

# algolia
export HEXO_ALGOLIA_INDEXING_KEY=d3e6a74afaebeb6b9c3a26eee410f08e
echo $HEXO_ALGOLIA_INDEXING_KEY
npx hexo algolia --flush true

echo ::set-output name=notify::"Deploy complate."
