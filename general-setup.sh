#!/bin/bash

if [[ $(ls) ]]; then

else

fi
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${__dir}/b.sh

wget -qO- https://gist.githubusercontent.com/NatelevAU/4bbf21663cc6cf9123e5a5fd198e7d14/raw/c2ebbd85127cf51fdd045dd1276d2bbee622199e/general-setup.sh | bash

