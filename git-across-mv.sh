#set -x

#Author: Haixun Lu
#Email: luhaixun@gmail.com

if [ $# -ne 2 ];then
  echo "Usage: $(basename $0) <src_path> <dest_path>"
  echo "Contact: luhaixun@gmail.com"
  exit 1
fi

_workspace="$(pwd)"
_src="${1}"
_dest="${2}"
_timestamp=$(date +%y%m%d%H%M%S)
_newbranch="refactor${_timestamp}"

_src_repo="${_src%%/*}";_src_path="${_src#*/}"

_dest_repo="${_dest%%/*}";_dest_path="${_dest#*/}"

_tmpfile="${_workspace}/.tmp${_timestamp}"

# rewrite log in _src component
cd "${_workspace}/${_src_repo}"
git checkout -b "${_newbranch}" origin/master

for f in "$(ls ${_src_path})"
do
  echo "${f}" >> ${_tmpfile}
done

git filter-branch --subdirectory-filter "${_src_path}" -- "${_newbranch}"

mkdir -p "${_dest_path}"
for f in $(cat ${_tmpfile})
do
  git mv "${f}" "${_dest_path}"
done

git commit -m "[Refactor] Remove ${_src}"
git remote rm origin

rm "${_tmpfile}"

# Put back to _dest component
cd "${_workspace}/${_dest_repo}"
git checkout -b "${_newbranch}" origin/master
git remote add "${_src_repo}" "${_workspace}/${_src_repo}"
git fetch "${_src_repo}" "${_newbranch}"

git merge "${_src_repo}/${_newbranch}" --allow-unrelated-histories -m "[Refactor] Put back ${_dest}"
git remote rm "${_src_repo}"
