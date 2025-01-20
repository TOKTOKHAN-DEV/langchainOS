#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Array of options
options=(
    "🚀 deploy   - Project deployment"
    "🤖 chore    - Minor changes"
    "📝 docs     - Documentation related"
    "🎸 feat     - New features or pages"
    "🐛 fix      - Bug fixes"
    "👽 perf     - Performance improvements"
    "💡 refactor - Code refactoring"
    "💍 test     - Test related"
    "🎨 style    - Styling related"
)

# Function to handle menu selection
menu() {
    local cursor=0
    local choice
    local key
    local num_options=${#options[@]}

    # Hide cursor
    tput civis

    while true; do
        # Clear previous menu
        echo -e "\033[H\033[2J"
        echo -e "${BLUE}Select commit type (use arrow keys):${NC}"

        for i in ${!options[@]}; do
            if [ $i -eq $cursor ]; then
                echo -e "> ${options[$i]}"
            else
                echo -e "  ${options[$i]}"
            fi
        done

        # Read single character
        read -rsn1 key
        case "$key" in
            $'\x1B')  # ESC sequence
                read -rsn1 key
                if [ "$key" = "[" ]; then
                    read -rsn1 key
                    case "$key" in
                        A)  # Up arrow
                            [ $cursor -gt 0 ] && ((cursor--))
                            ;;
                        B)  # Down arrow
                            [ $cursor -lt $((${#options[@]}-1)) ] && ((cursor++))
                            ;;
                    esac
                fi
                ;;
            "")  # Enter key
                echo
                choice=$((cursor + 1))
                break
                ;;
        esac
    done

    # Show cursor again
    tput cnorm

    type_choice=$choice
}

menu

# Extract emoji and type from selected option
selected_option="${options[$((type_choice-1))]}"
emoji=$(echo "$selected_option" | cut -d' ' -f1)
type=$(echo "$selected_option" | cut -d' ' -f2)


# Get commit message
read -p "Enter commit message: " commit_message

# Generate final commit message
final_message="$emoji $type: $commit_message"

# Check if there are staged files
if git diff --staged --quiet; then
    echo -e "${YELLOW}No staged files found. Please run git add first.${NC}"
    exit 1
fi

# Execute commit
git commit -m "$final_message"

# Print success message
echo -e "${GREEN}Commit successfully created:${NC}"
echo "$final_message"