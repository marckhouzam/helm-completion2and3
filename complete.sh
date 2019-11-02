#!/usr/bin/env sh
#
# Copyright 2019 Marc Khouzam <marc.khouzam@gmail.com>
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.


usage() {
    echo "Helm plugin to enable autocompletion for helm2 and helm3 at the same time"
    echo
    echo "Source the output of the plugin to enable completion for both versions of helm"
    echo
    echo "Usage: helm completion2and3 <bash|zsh> <helm2> <helm3>"
    echo
    echo "Example:"
    echo "  source <(helm completion2and3 bash helm helm3)"
    echo "      where 'helm' and 'helm3' can be found in \$PATH"
    exit $1
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
fi
[ $# -ne 3 ] && usage 1

shell=$1
helm2=$2
helm3=$3

echo "#######################################################"
echo "##############  Helm 2 completion script ##############"
echo "#######################################################"

# Don't call helm2 to generate its completion script right away.
# Instead, let the it be called when the user sources the final script.
# This allow for $helm2 to be an alias known to the user's shell.
echo "
# Don't use the new source <() form as it does not work with bash v3
source /dev/stdin <<- EOF
   \$($helm2 completion $shell)
EOF
"

echo
echo "#######################################################"
echo "##############  Helm 3 completion script ##############"
echo "#######################################################"

# Don't call helm3 to generate its completion script right away.
# Instead, let the it be called when the user sources the final script.
# This allow for $helm3 to be an alias known to the user's shell.
echo "
# Don't use the new source <() form as it does not work with bash v3
source /dev/stdin <<- EOF
   \$($helm3 completion $shell | sed s/helm/helm3/g)
EOF
"

echo
echo "#######################################################"
echo "######## Method to verify which helm is used ##########"
echo "#######################################################"

cat <<EOF

__helm_choose_version()
{
    # Must use -c flag to avoid helm v2 trying to contact the cluster
    if eval \${COMP_WORDS[0]} version -c --tls &> /dev/null; then
        # The --tls flag to helm version exists: it's helm2
        __start_helm
    else
        # The --tls flag to helm version does not exist: it's helm3
        __start_helm3
    fi
}
EOF

if [ $shell = bash ]; then
cat <<EOF

# Hook any binary named helm to a function that will figure out
# if it is helm2 or helm3
if [[ \$(type -t compopt) = "builtin" ]]; then
    complete -o default -F __helm_choose_version helm
else
    complete -o default -o nospace -F __helm_choose_version helm
fi
EOF
else
cat <<EOF

# Hook any binary named helm to a function that will figure out
# if it is helm2 or helm3
complete -o default -F __helm_choose_version helm
EOF
fi
