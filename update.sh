#!/usr/bin/env bash
rime_dir=$(dirname "$0")
pushd ${rime_dir}

git clone --depth 1 https://github.com/rime/plum.git || pushd plum && git fetch --all --tags --prune && git reset --hard origin/master && popd
bash ./plum/rime-install prelude essay luna-pinyin double-pinyin
git clone --depth 1 https://github.com/alswl/Rime.git alswl-Rime || pushd alswl-Rime && git fetch --all --tags --prune && git reset --hard origin/master && popd
for f in alswl-Rime/*.dict.yaml; do
    cp -f "$f" .
done

latest_obj=$(curl https://api.github.com/repos/felixonmars/fcitx5-pinyin-zhwiki/releases/latest -s | jq -c '[.assets[]|select(.name|endswith(".dict.yaml"))]|sort_by(.name)|.[-1]|{name:.name,url:.browser_download_url}')
latest_file=$(echo "$latest_obj" | jq -r .name)
latest_url=$(echo "$latest_obj" | jq -r .url)
save_file=zhwiki.dict.yaml
if [[ ! -f $save_file ]] ||
    [[ ! -f $save_file.version ]] ||
    [[ $(cat $save_file.version) != "$latest_file" ]]; then
    curl -L "$latest_url" -o "$save_file"
fi
echo "$latest_file" >"${save_file}.version"

latest_tag=$(curl https://api.github.com/repos/outloudvi/mw2fcitx/releases/latest -s | jq .tag_name -r)
latest_file=moegirl-$latest_tag.dict.yaml
latest_url=https://github.com/outloudvi/mw2fcitx/releases/latest/download/moegirl.dict.yaml
save_file=moegirl.dict.yaml
if [[ ! -f $save_file ]] ||
    [[ ! -f $save_file.version ]] ||
    [[ $(cat $save_file.version) != "$latest_file" ]]; then
    curl -L "$latest_url" -o "$save_file"
fi
echo "$latest_file" >"${save_file}.version"

popd
