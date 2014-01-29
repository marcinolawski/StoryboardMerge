#!/bin/sh
set -e

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcassets)
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
install_resource "ACEView/ACEView/Dependencies/ace/src/ace.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/ext-static_highlight.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/ext-textarea.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/keybinding-emacs.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/keybinding-vim.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-asciidoc.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-c9search.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-c_cpp.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-clojure.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-coffee.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-coldfusion.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-csharp.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-css.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-diff.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-glsl.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-golang.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-groovy.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-haxe.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-html.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-jade.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-java.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-javascript.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-json.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-jsp.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-jsx.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-latex.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-less.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-liquid.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-lua.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-luapage.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-markdown.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-ocaml.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-perl.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-pgsql.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-php.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-powershell.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-python.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-ruby.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-scad.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-scala.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-scss.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-sh.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-sql.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-svg.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-tcl.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-text.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-textile.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-typescript.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-xml.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-xquery.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/mode-yaml.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-ambiance.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-chrome.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-clouds.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-clouds_midnight.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-cobalt.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-crimson_editor.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-dawn.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-dreamweaver.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-eclipse.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-github.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-idle_fingers.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-kr.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-merbivore.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-merbivore_soft.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-mono_industrial.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-monokai.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-pastel_on_dark.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-solarized_dark.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-solarized_light.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-textmate.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-tomorrow.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-tomorrow_night.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-tomorrow_night_blue.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-tomorrow_night_bright.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-tomorrow_night_eighties.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-twilight.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-vibrant_ink.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/theme-xcode.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/worker-coffee.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/worker-css.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/worker-javascript.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/worker-json.js"
install_resource "ACEView/ACEView/Dependencies/ace/src/worker-xquery.js"
install_resource "ACEView/ACEView/HTML/index.html"

rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ `xcrun --find actool` ] && [ `find . -name '*.xcassets' | wc -l` -ne 0 ]
then
  case "${TARGETED_DEVICE_FAMILY}" in 
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;  
  esac 
  find "${PWD}" -name "*.xcassets" -print0 | xargs -0 actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
