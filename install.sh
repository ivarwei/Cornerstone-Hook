#
# install shell
#
root_dir=`pwd`
build_dir='build'
project_name='Cornerstone'
echo "build dylib..."
xcodebuild  -project "${project_name}.xcodeproj" \
			-scheme "${project_name}" \
			-configuration "Release" \
			-derivedDataPath "./${build_dir}" \
			-quiet \
			ONLY_ACTIVE_ARCH=NO \
			clean build 


# update dylib
product_lib_path="${root_dir}/${build_dir}/Build/Products/Release/lib${project_name}.dylib"
target_dir="${root_dir}/${project_name}/${project_name}Start.app/Contents/Frameworks/"
# echo "product_lib_path: ${product_lib_path}"
# echo "target_dir: ${target_dir}"
echo "update start app..."
cp -R "${product_lib_path}" "${target_dir}"

# delete build product
rm -r "${root_dir}/${build_dir}/" 

# copy start app to Application Document
echo "copy star app..."
rm -r "/Applications/${project_name}Start.app"
cp -R "${root_dir}/${project_name}/${project_name}Start.app" "/Applications"

echo "success..."


