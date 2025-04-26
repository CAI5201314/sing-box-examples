#!/bin/bash

LOG_DIR="hppro"
LOG_FILE="log.txt"

mkdir -p "$LOG_DIR"

menu() {
    echo "========= 脚本菜单 ========="
    echo "1. 运行"
    echo "2. 停止"
    echo "3. 查看日志"
    echo "4. 退出"
    echo "============================"
    read -p "请选择操作：[1-4] " choice
    case "$choice" in
        1)
            run
            ;;
        2)
            stop
            ;;
        3)
            view_logs
            ;;
        4)
            exit 0
            ;;
        *)
            echo "无效的选择，请重新输入！"
            menu
            ;;
    esac
}

run() {
    echo "========= 选择文件类型 ========="
    echo "1. hp-pro-amd64"
    echo "2. hp-pro-arm64"
    echo "3. hp-pro-armv7"
    echo "4. hp-pro-mipsle"
    echo "==============================="
    read -p "请选择文件类型：[1-4] " file_choice
    case "$file_choice" in
        1)
            file_type="hp-pro-amd64"
            ;;
        2)
            file_type="hp-pro-arm64"
            ;;
        3)
            file_type="hp-pro-armv7"
            ;;
        4)
            file_type="hp-pro-mipsle"
            ;;
        *)
            echo "无效的选择，请重新输入！"
            run
            ;;
    esac

    if [ ! -f "$LOG_DIR/$file_type" ]; then
        echo "文件不存在，从 https://hpproxy.cn/bin/$file_type 下载中..."
        wget "https://hpproxy.cn/bin/$file_type" -P "$LOG_DIR"
    fi

    if pgrep -f "hp-pro" >/dev/null; then
        echo "已经有包含 hp-pro 的程序在运行，请先停止运行！"

    else
        read -p "请输入设备ID：" device_id
        chmod +x ./"$LOG_DIR/$file_type"
        nohup ./"$LOG_DIR/$file_type" -deviceId="$device_id" > "$LOG_DIR/$LOG_FILE" 2>&1 &
        echo "文件已运行！"
    fi

    menu
}

stop() {
    echo "停止 hp-pro 相关程序..."
    pkill -f "hp-pro"
    menu
}

view_logs() {
    if pgrep -f "hp-pro" >/dev/null; then
        echo "实时查看日志..."
        tail -f "$LOG_DIR/$LOG_FILE"
    else
        echo "没有 hp-pro 程序在运行，无法查看日志！"
    fi
    menu
}

menu
