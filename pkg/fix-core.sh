#!/bin/bash
root_dir=$(cd `dirname $0`/.. && pwd -P)

package_dir="$root_dir/package.nw"
tmp_dir="$root_dir/tmp/core"
mkdir -p $tmp_dir
unpack_script="$root_dir/tools/wxvpkg_unpack.js"
pack_script="$root_dir/tools/wxvpkg_pack.js"
 
echo "Fix Core"
# unpack 文件 到 路径
node "$unpack_script" "$package_dir/core.wxvpkg" "$tmp_dir/core.wxvpkg"

#    ____  _____ ____  _        _    ____ _____    ____ ___  ____  _____ 
#   |  _ \| ____|  _ \| |      / \  / ___| ____|  / ___/ _ \|  _ \| ____|
#   | |_) |  _| | |_) | |     / _ \| |   |  _|   | |  | | | | |_) |  _|  
#   |  _ <| |___|  __/| |___ / ___ \ |___| |___  | |__| |_| |  _ <| |___ 
#   |_| \_\_____|_|   |_____/_/   \_\____|_____|  \____\___/|_| \_\_____|
#                                                                        

# find
open_find_result=$( grep -lr "this.props.onWindowOpenFail());if" "$tmp_dir/core.wxvpkg" )
echo "云开发控制台启动点: $open_find_result"
if [[ ! -z $open_find_result ]];then
  # replace
  new_cb_handle="this.props.onWindowOpenFail());Object.keys(window).forEach(key=>{if(!e.window[key]){try{e.window[key]=window[key];}catch(e){console.error(e);}}});"
  sed -i "s/this.props.onWindowOpenFail());/$new_cb_handle/g" $open_find_result
fi

token_find_result=$( grep -lr "constructor(){this._sessionToken=\"\",this._tokenMap={}}" "$tmp_dir/core.wxvpkg" )
echo "WebSocket token存储对象位置: $token_find_result"
if [[ ! -z $token_find_result ]];then
  new_constructor="constructor(){if(window.tokenData){/*有就直接用*/this._sessionToken=window.tokenData._sessionToken;this._tokenMap=window.tokenData._tokenMap;}else{/*没有就新建*/this._sessionToken=\"\",this._tokenMap={};window.tokenData=this;/*新建完要给中间人*/}}"
  sed -i "s#constructor(){this._sessionToken=\"\",this._tokenMap={}}#$new_constructor#g" "$token_find_result"
fi

# open -a Terminal "`pwd`" --> gnome-terminal
find_result=$( grep -lr 'open -a Terminal "`pwd`"' "$tmp_dir/core.wxvpkg" )
if [[ ! -z $find_result ]];then
  echo "Terminal启动位置: $find_result"
  new_str="gnome-terminal"
  sed -i "s#open -a Terminal \"\`pwd\`\"#$new_str#g" "$find_result"
fi

# wcc、wcsc处理，设置NO_WINE=true环境变量生效
if [[ $NO_WINE == 'true' ]];then
  # "wcc.exe":!0,"wcsc.exe":!0
  find_result=$( grep -lr '{wcc:!0,wcsc:!0,DevToolProtector:!0}' "$tmp_dir/core.wxvpkg" )
  if [[ ! -z $find_result ]];then
    echo "wcc: $find_result"
    new_str='{"wcc.bin":!0,"wcsc.bin":!0,wcc:!0,wcsc:!0,DevToolProtector:!0}'
    sed -i "s#{wcc:!0,wcsc:!0,DevToolProtector:!0}#$new_str#g" "$find_result"
    new_str='"linux"===process.platform'
    sed -i "s#\"darwin\"===process.platform#$new_str#g" "$find_result"
    sed -i 's#return I("wcc")#return I("wcc.bin"),I("wcc")#g' "$find_result"
    sed -i 's#return I("wcsc")#return I("wcsc.bin"),I("wcsc")#g' "$find_result"
  fi

  current=`date "+%Y-%m-%d %H:%M:%S"`
  timeStamp=`date -d "$current" +%s`
  echo $timeStamp > "${package_dir}/.build_time"
fi

# pack 路径 到 文件
echo "pack"
node "$pack_script" "$tmp_dir/core.wxvpkg" "$package_dir/core.wxvpkg"
rm -rf "$tmp_dir/core.wxvpkg"
