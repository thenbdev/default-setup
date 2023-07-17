
for d in /home/nbNext/frappe-bench/apps/* ; do
    echo "Resetting git in $d"
    cd "$d"
    git fetch && git reset --hard upstream/develop-updated
    cd ..
done
