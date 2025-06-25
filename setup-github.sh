#!/bin/bash

# 🚀 GitHub Repository Setup Script cho Moodle 5.0.1
# Script này sẽ giúp bạn push code lên GitHub và thiết lập Codespaces

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Moodle 5.0.1 GitHub Setup${NC}"
echo -e "${BLUE}==============================${NC}"

# Kiểm tra Git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Không tìm thấy Git repository!${NC}"
    echo -e "${YELLOW}Khởi tạo Git repository...${NC}"
    git init
    echo -e "${GREEN}✅ Git repository đã được khởi tạo${NC}"
fi

# Kiểm tra xem có commit nào chưa
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Chưa có commit nào trong repository${NC}"
    echo -e "${YELLOW}Tạo initial commit...${NC}"
    git add .
    git commit -m "🎉 Initial commit: Moodle 5.0.1 LMS project setup for GitHub Codespaces"
    echo -e "${GREEN}✅ Initial commit đã được tạo${NC}"
fi

# Hỏi thông tin GitHub repository
echo -e "\n${YELLOW}📝 Nhập thông tin GitHub repository:${NC}"
read -p "GitHub username: " GITHUB_USERNAME
read -p "Repository name: " REPO_NAME

if [ -z "$GITHUB_USERNAME" ] || [ -z "$REPO_NAME" ]; then
    echo -e "${RED}❌ Vui lòng nhập đầy đủ thông tin!${NC}"
    exit 1
fi

GITHUB_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"

echo -e "\n${BLUE}📋 Thông tin repository:${NC}"
echo -e "  GitHub URL: $GITHUB_URL"
echo -e "  Branch: main"

# Hỏi xác nhận
read -p "Bạn có muốn tiếp tục? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}⏹️  Hủy bỏ setup${NC}"
    exit 0
fi

# Kiểm tra và thêm remote origin
if git remote get-url origin >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Remote origin đã tồn tại${NC}"
    current_url=$(git remote get-url origin)
    echo -e "Current URL: $current_url"
    read -p "Bạn có muốn thay đổi URL? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote set-url origin "$GITHUB_URL"
        echo -e "${GREEN}✅ Remote origin URL đã được cập nhật${NC}"
    fi
else
    echo -e "${YELLOW}🔗 Thêm remote origin...${NC}"
    git remote add origin "$GITHUB_URL"
    echo -e "${GREEN}✅ Remote origin đã được thêm${NC}"
fi

# Đặt branch chính là main
echo -e "${YELLOW}🌿 Thiết lập branch main...${NC}"
git branch -M main

# Push code lên GitHub
echo -e "${YELLOW}📤 Push code lên GitHub...${NC}"
if git push -u origin main; then
    echo -e "${GREEN}✅ Code đã được push thành công!${NC}"
else
    echo -e "${RED}❌ Có lỗi khi push code${NC}"
    echo -e "${YELLOW}💡 Một số lý do có thể:${NC}"
    echo -e "  - Repository chưa tồn tại trên GitHub"
    echo -e "  - Bạn chưa có quyền truy cập"
    echo -e "  - Cần xác thực GitHub"
    echo -e "\n${YELLOW}🔧 Hướng dẫn khắc phục:${NC}"
    echo -e "1. Tạo repository '$REPO_NAME' trên GitHub.com"
    echo -e "2. Đảm bảo repository là public hoặc bạn có quyền truy cập"
    echo -e "3. Thiết lập GitHub authentication (token hoặc SSH key)"
    echo -e "4. Chạy lại script này"
    exit 1
fi

echo -e "\n${GREEN}🎉 Thiết lập hoàn tất!${NC}"
echo -e "\n${BLUE}📋 Các bước tiếp theo:${NC}"
echo -e "1. 🌐 Truy cập: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo -e "2. 💻 Tạo Codespace:"
echo -e "   - Click nút xanh 'Code'"
echo -e "   - Chọn tab 'Codespaces'"
echo -e "   - Click 'Create codespace on main'"
echo -e "3. ⏱️  Đợi 5-10 phút để Codespace khởi động"
echo -e "4. 🚀 Bắt đầu phát triển Moodle!"

echo -e "\n${YELLOW}📚 Tài liệu hướng dẫn:${NC}"
echo -e "  - CODESPACES_GUIDE.md: Hướng dẫn chi tiết sử dụng Codespaces"
echo -e "  - README.md: Thông tin tổng quan về project"

echo -e "\n${BLUE}🔗 Liên kết hữu ích:${NC}"
echo -e "  Repository: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo -e "  Codespaces: https://github.com/$GITHUB_USERNAME/$REPO_NAME/codespaces"
echo -e "  Issues: https://github.com/$GITHUB_USERNAME/$REPO_NAME/issues"

echo -e "\n${GREEN}Happy coding with Moodle 5.0.1! 🎓${NC}"
