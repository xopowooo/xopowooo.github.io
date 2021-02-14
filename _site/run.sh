#!/bin/bash
echo "start generating files..."

posts_dir="./_posts"
sub_folder="$posts_dir/mul/"

langs=("ru" "zh" "en")

if [ -d $sub_folder ]; then
    rm -rf "$sub_folder"
fi
mkdir "$sub_folder"

posts_filenames=`ls $posts_dir/*.markdown`
for lang in ${langs[*]}; do
    for post_filename in $posts_filenames; do
        # echo $post_filename
        base_filename=$(basename "$post_filename")
        new_post_filename="$sub_folder${base_filename//.markdown/_$lang.markdown}"
        # echo $new_post_filename
        cnt=0
        while IFS= read -r line; do
            if [ "${line}" = "---" ]; then
                ((cnt+=1))
                if [ $cnt = 2 ]; then
                    if [ "$lang" = "en" ]; then
                        nav_str=""
                    else
                        nav_str="_$lang"
                    fi
                    echo "" >> "${new_post_filename}"
                    echo "nav: \"post$nav_str.html\"" >> "${new_post_filename}"
                fi
                echo ${line} >> "${new_post_filename}"
            else
                echo ${line} >> "${new_post_filename}"
            fi
        done < "$post_filename"
    done
done

echo "done! :)"
