#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Global error counters
total_violations=0
total_files_checked=0
files_with_violations=0

# Function to print error messages in red
print_error() {
    echo -e "${RED}$1${NC}"
}

# Function to print success messages in green
print_success() {
    echo -e "${GREEN}$1${NC}"
}

# Function to print warning messages in yellow
print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

# Function to check a SQL file
check_file() {
    local file=$1
    local file_violations=0
    local content
    
    # Read file content while preserving line breaks
    content=$(<"$file")
    
    # Convert content to a single line to handle multi-line queries
    # Replace line breaks with spaces while preserving semicolons
    content_oneline=$(echo "$content" | tr '\n' ' ')
    
    # Split into individual queries (separated by semicolons)
    IFS=';' read -ra queries <<< "$content_oneline"
    
    local first_violation=true
    for query in "${queries[@]}"; do
        # Check for UPDATE without WHERE clause
        if [[ $query =~ [Uu][Pp][Dd][Aa][Tt][Ee][[:space:]]+[[:alnum:]_]+[[:space:]] && ! $query =~ [Ww][Hh][Ee][Rr][Ee] ]]; then
            if $first_violation; then
                print_error "File: $file"
                first_violation=false
            fi
            print_error "  VIOLATION: UPDATE statement without WHERE clause"
            print_error "  Query: $query"
            echo ""
            file_violations=$((file_violations + 1))
            total_violations=$((total_violations + 1))
        fi
        
        # Check for wildcard usage
        if [[ $query =~ SELECT.*[[:space:]]\*[[:space:]] ]]; then
            if $first_violation; then
                print_error "File: $file"
                first_violation=false
            fi
            print_error "  VIOLATION: Use of wildcard (*) in SELECT statement"
            print_error "  Query: $query"
            echo ""
            file_violations=$((file_violations + 1))
            total_violations=$((total_violations + 1))
        fi
    done
    
    if [ $file_violations -gt 0 ]; then
        files_with_violations=$((files_with_violations + 1))
    fi
    
    return $file_violations
}

echo "Starting SQL files analysis..."
echo "----------------------------------------"

# Check all SQL files recursively
while IFS= read -r -d '' file; do
    total_files_checked=$((total_files_checked + 1))
    check_file "$file"
done < <(find . -type f -name "*.sql" -print0)

echo "----------------------------------------"
echo "Analysis Summary:"
if [ $total_violations -eq 0 ]; then
    print_success "✓ No violations found"
    print_success "✓ $total_files_checked files analyzed"
    exit 0
else
    print_error "✗ Total violations found: $total_violations"
    print_error "✗ Files with violations: $files_with_violations out of $total_files_checked"
    exit $total_violations
fi