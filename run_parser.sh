# shellcheck disable=SC2044
for filename in $(find test/*.txt)
do
	./compiled_parser $filename
done
