git add . &&
git commit -m "$1" && 
git push origin master &&
ssh root@51.77.245.118<<EOF
cd discordo  &&
git pull origin master &&
stack build &&
lsof -i:443 -Fp | sed 's/^p//' | head -n -1 | xargs kill -9;
nohup stack exec aulahaskell > /dev/null
echo "deploy finished"
EOF