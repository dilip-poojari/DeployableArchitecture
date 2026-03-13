#!/bin/bash
##############################################################################
# Package Script for IBM Cloud Private Catalog
# Creates a .tgz archive of the Deployable Architecture
##############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DA_NAME="openshift-ai-roks-da"
VERSION="1.0.0"
OUTPUT_DIR="./dist"
ARCHIVE_NAME="${DA_NAME}-${VERSION}.tgz"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}IBM Cloud DA Packaging Script${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Create output directory
echo -e "${YELLOW}Creating output directory...${NC}"
mkdir -p "$OUTPUT_DIR"

# Clean previous builds
if [ -f "$OUTPUT_DIR/$ARCHIVE_NAME" ]; then
    echo -e "${YELLOW}Removing previous archive...${NC}"
    rm "$OUTPUT_DIR/$ARCHIVE_NAME"
fi

# Files and directories to include
echo -e "${YELLOW}Preparing files for packaging...${NC}"
FILES_TO_PACKAGE=(
    "main.tf"
    "variables.tf"
    "outputs.tf"
    "version.tf"
    "README.md"
    "metadata.json"
    "modules/"
    "examples/"
)

# Files to exclude
EXCLUDE_PATTERNS=(
    "*.tfstate*"
    "*.terraform*"
    ".git*"
    "dist/"
    "*.log"
    "kubeconfig/"
    ".DS_Store"
)

# Build exclude arguments for tar
EXCLUDE_ARGS=""
for pattern in "${EXCLUDE_PATTERNS[@]}"; do
    EXCLUDE_ARGS="$EXCLUDE_ARGS --exclude=$pattern"
done

# Validate required files exist
echo -e "${YELLOW}Validating required files...${NC}"
REQUIRED_FILES=("main.tf" "variables.tf" "outputs.tf" "version.tf" "README.md" "metadata.json")
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}Error: Required file '$file' not found!${NC}"
        exit 1
    fi
done

# Validate Terraform syntax
echo -e "${YELLOW}Validating Terraform syntax...${NC}"
if command -v terraform &> /dev/null; then
    terraform fmt -check -recursive . || {
        echo -e "${YELLOW}Warning: Terraform formatting issues detected. Run 'terraform fmt -recursive .' to fix.${NC}"
    }
    terraform init -backend=false > /dev/null 2>&1 || true
    terraform validate > /dev/null 2>&1 || {
        echo -e "${YELLOW}Warning: Terraform validation issues detected.${NC}"
    }
else
    echo -e "${YELLOW}Warning: Terraform not found. Skipping validation.${NC}"
fi

# Create the archive
echo -e "${YELLOW}Creating archive: $ARCHIVE_NAME${NC}"
tar -czf "$OUTPUT_DIR/$ARCHIVE_NAME" $EXCLUDE_ARGS "${FILES_TO_PACKAGE[@]}" 2>/dev/null

# Verify archive was created
if [ ! -f "$OUTPUT_DIR/$ARCHIVE_NAME" ]; then
    echo -e "${RED}Error: Failed to create archive!${NC}"
    exit 1
fi

# Get archive size
ARCHIVE_SIZE=$(du -h "$OUTPUT_DIR/$ARCHIVE_NAME" | cut -f1)

# List contents of archive
echo ""
echo -e "${GREEN}Archive created successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "Archive: ${GREEN}$OUTPUT_DIR/$ARCHIVE_NAME${NC}"
echo -e "Size: ${GREEN}$ARCHIVE_SIZE${NC}"
echo ""
echo -e "${YELLOW}Archive contents:${NC}"
tar -tzf "$OUTPUT_DIR/$ARCHIVE_NAME" | head -20
TOTAL_FILES=$(tar -tzf "$OUTPUT_DIR/$ARCHIVE_NAME" | wc -l)
echo -e "... (${TOTAL_FILES} total files)"
echo ""

# Generate checksum
echo -e "${YELLOW}Generating checksum...${NC}"
if command -v sha256sum &> /dev/null; then
    CHECKSUM=$(sha256sum "$OUTPUT_DIR/$ARCHIVE_NAME" | cut -d' ' -f1)
    echo "$CHECKSUM" > "$OUTPUT_DIR/$ARCHIVE_NAME.sha256"
    echo -e "SHA256: ${GREEN}$CHECKSUM${NC}"
elif command -v shasum &> /dev/null; then
    CHECKSUM=$(shasum -a 256 "$OUTPUT_DIR/$ARCHIVE_NAME" | cut -d' ' -f1)
    echo "$CHECKSUM" > "$OUTPUT_DIR/$ARCHIVE_NAME.sha256"
    echo -e "SHA256: ${GREEN}$CHECKSUM${NC}"
else
    echo -e "${YELLOW}Warning: sha256sum/shasum not found. Skipping checksum generation.${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Packaging Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Upload $ARCHIVE_NAME to your GitHub repository"
echo "2. Create a release with this archive"
echo "3. Import into IBM Cloud Private Catalog:"
echo "   - Go to IBM Cloud Console > Catalog Management"
echo "   - Create or select a private catalog"
echo "   - Click 'Add' > 'Deployable Architecture'"
echo "   - Provide the GitHub release URL"
echo ""
echo -e "${GREEN}For more information, visit:${NC}"
echo "https://cloud.ibm.com/docs/account?topic=account-create-private-catalog"
echo ""

# Made with Bob
