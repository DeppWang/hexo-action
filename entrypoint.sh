#!/bin/sh

set -e

# setup ssh-private-key
mkdir -p /root/.ssh/
echo "$INPUT_DEPLOY_KEY" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

# setup deploy git account
git config --global user.name "$INPUT_USER_NAME"
git config --global user.email "$INPUT_USER_EMAIL"

# install hexo env
npm install hexo-cli -g
npm install hexo-deployer-git --save
npm install hexo-algolia --save

# deployment
hexo g -d

# algolia
export HEXO_ALGOLIA_INDEXING_KEY=d3e6a74afaebeb6b9c3a26eee410f08e
echo $HEXO_ALGOLIA_INDEXING_KEY
hexo algolia

echo ::set-output name=notify::"Deploy complate."
