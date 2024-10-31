#!/bin/bash


# 默认参数
TARGET_DIR=$HOME/clash
DOWNLOAD_OPTION="yes"
BASH_UPDATE_OPTION="yes"
CLASH_URL="https://raw.githubusercontent.com/LttGenius/cflinux_proxy/refs/heads/main/clash"  # 替换为实际的 Clash 文件下载链接

# 解析参数
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --dir)
            TARGET_DIR="$2"
            shift 2
            ;;
        --nodown)
            DOWNLOAD_OPTION="no"
            shift
            ;;
        --nobash)
            BASH_UPDATE_OPTION="no"
            shift
            ;;
        *)
            echo "未知参数: $1"
            exit 1
            ;;
    esac
done

# # 创建目标文件夹
mkdir -p "$TARGET_DIR"
mkdir -p "$TARGET_DIR/log"

# # 下载 Clash 文件
if [[ "$DOWNLOAD_OPTION" == "yes" ]]; then
    echo "正在下载 Clash 文件到 $TARGET_DIR ..."
    curl -L "$CLASH_URL" -o "$TARGET_DIR/clash"  # 将下载的文件命名为 clash
    # 给下载的文件赋予可执行权限
    chmod +x "$TARGET_DIR/clash"
else
    echo "跳过 Clash 文件下载。"
fi

# 将 clashof 函数添加到 ~/.bashrc
# 检查是否需要将 clashof 函数写入到 ~/.bashrc
if [[ "$BASH_UPDATE_OPTION" == "yes" ]]; then
BASHRC_FILE="$HOME/.bashrc"
echo "# >>> clashof initialize >>>" >> "$BASHRC_FILE"
echo "CLASH_PATH=\$HOME/tools/clash/" >> "$BASHRC_FILE"
cat << 'EOF' >> "$BASHRC_FILE"

__clash_app_on(){
    if pgrep -u "$(whoami)" -f "$CLASH_PATH" > /dev/null; then
        # 删除log文件
        echo "Clash has been enabled."
    else
        # 启用 Clash
        nohup "$CLASH_PATH/clash" > "$CLASH_PATH/log/clash.log" 2>&1 &
        echo -e "\e[32mClash enabled successfully.\e[0m" 
    fi
}

__clash_app_off(){
    if pgrep -u "$(whoami)" -f "$CLASH_PATH" > /dev/null; then
        pkill -u "$(whoami)" -f "$CLASH_PATH"
        # rm -f "$CLASH_PATH/log/clash.log"
        echo -e "\e[32mClash disabled successfully.\e[0m"
    else
        echo "Clash is not enabled."
    fi
}

__http_proxy_on(){
    # 检查代理是否已设置
    if [ -z "$http_proxy" ] && [ -z "$https_proxy" ]; then
        export http_proxy="http://127.0.0.1:7890"
        export https_proxy="http://127.0.0.1:7890"
        echo -e "\e[32mHTTP/HTTPS Proxy enabled.\e[0m"
    else
        echo "HTTP/HTTPS Proxy is already enabled."
    fi
}

__http_proxy_off(){
    # 检查代理是否已设置
    if [ -n "$http_proxy" ] && [ -n "$https_proxy" ]; then
        unset http_proxy
        unset https_proxy
        echo -e "\e[32mHTTP/HTTPS Proxy disabled.\e[0m"
    else
        echo "HTTP/HTTPS Proxy is not enabled."
    fi
}

clashof() {
    # clashof 用于启用/关闭 Clash及代理
    # 命令解释：
    #  clashof: 如此时终端没有开启代理和clash，则开启代理和clash；否则关闭代理和clash
    #  clashof on: 启用 Clash及代理
    #  clashof off: 关闭 Clash及代理
    #  clashof status: 查看 Clash及代理状态
    #  clashof help: 查看帮助
    #  clashof proxy on: 启用代理
    #  clashof proxy off: 关闭代理
    #  clashof clash on: 启用 Clash
    #  clashof clash off: 关闭 Clash
    case "$1" in
        on)
            __clash_app_on
            __http_proxy_on
            ;;
        off)
            __clash_app_off
            __http_proxy_off
            ;;
        status)
            # 查看 Clash 和代理的状态
            if pgrep -u "$(whoami)" -f "$CLASH_PATH" > /dev/null; then
                echo -e "\e[33mClash is running.\e[0m"
                # 查看 Clash 进程的 PID
                pid=$(pgrep -u "$(whoami)" -f "$CLASH_PATH")
                echo -e "\e[35mClash PID: $pid\e[0m"
            else
                echo -e "\e[32mClash is not running.\e[0m"
            fi

            if [ -n "$http_proxy" ] && [ -n "$https_proxy" ]; then
                echo -e "\e[33mHTTP/HTTPS Proxy is enabled.\e[0m"
                # 查看代理设置
                echo -e "\e[35mHTTP Proxy: $http_proxy\e[0m"
                echo -e "\e[35mHTTPS Proxy: $https_proxy\e[0m"
            else
                echo -e "\e[32mHTTP/HTTPS Proxy is disabled.\e[0m"
            fi
            ;;
        help)
            echo -e "\e[36m=====================================clashof=====================================\e[0m"
            echo -e "\e[36mUsage: clashof [on|off|status|help|proxy [on|off]|clash [on|off]]\e[0m"
            echo -e "\e[36m-----------------------------------------------------------------\e[0m"
            echo -e "\e[36mclashof           |  如此时终端没有开启代理和clash，则开启代理和clash；否则关闭代理和clash\e[0m"
            echo -e "\e[36mclashof on        |  启用 Clash及代理\e[0m"
            echo -e "\e[36mclashof off       |  关闭 Clash及代理\e[0m"
            echo -e "\e[36mclashof status    |  查看 Clash及代理状态\e[0m"
            echo -e "\e[36mclashof help      |  查看帮助\e[0m"
            echo -e "\e[36mclashof proxy on  |  启用代理\e[0m"
            echo -e "\e[36mclashof proxy off |  关闭代理\e[0m"
            echo -e "\e[36mclashof clash on  |  启用 Clash\e[0m"
            echo -e "\e[36mclashof clash off |  关闭 Clash\e[0m"
            echo -e "\e[36m==============================>all papers accepted<==============================\e[0m"
            ;;
        proxy)
            case "$2" in
                on)
                    __http_proxy_on
                    ;;
                off)
                    __http_proxy_off
                    ;;
                *)
                    echo -e "\e[31mInvalid command: $2, use 'clashof help' to get help.\e[0m"
                    ;;
            esac
            ;;
        clash)
            case "$2" in
                on)
                    clash_on
                    ;;
                off)
                    clash_off
                    ;;
                *)
                    echo -e "\e[31mInvalid command: $2, use 'clashof help' to get help.\e[0m"
                    ;;
            esac
            ;;
        "")
            # 如果没有参数，则切换当前用户的 Clash 和代理的开关 (以为clash是否开启为标准)
            if pgrep -u "$(whoami)" -f "$CLASH_PATH" > /dev/null; then
                if [ -z "$http_proxy" ] && [ -z "$https_proxy" ]; then
                    __http_proxy_on
                    echo -e "\e[34mClash and proxy enabled.\e[0m"
                else
                    __http_proxy_off
                    __clash_app_off
                    echo -e "\e[34mClash and proxy disabled.\e[0m"
                fi
            else
                __clash_app_on
                __http_proxy_on
                echo -e "\e[34mClash and proxy enabled.\e[0m"
            fi
            ;;
        *)
            echo -e "\e[31mInvalid command: $1, use 'clashof help' to get help.\e[0m"
            ;;
    esac
}
# <<< clashof initialize <<<
EOF

# 提示用户重新加载 .bashrc
echo -e "\e[34m.bashrc 文件已更新。请运行 'source ~/.bashrc' 使更改生效。\e[0m"
else
    echo "跳过 .bashrc 文件更新。"
fi