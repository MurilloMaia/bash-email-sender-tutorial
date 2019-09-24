#!/bin/bash

function get-username-by-email(){
    echo "${1%%@*}"
}

function process-user(){
    local USER_NAME=$1
    local USER_PASS=$2

    echo "Creating ${USER_NAME} with password ${USER_PASS}"

    if [[ $USER_NAME == "devil" ]]; then 
        return 1
    else 
        return 0
    fi
}

function process-user(){
    local USER_NAME=$1
    local USER_PASS=$2

    echo "Creating ${USER_NAME} with password ${USER_PASS}"

    if [[ $USER_NAME == "devil" ]]; then 
        return 1
    else 
        return 0
    fi
}

function email-pattern() {
    USER_NAME=${1}
    USER_PASS=${2}
    cat <<EOF

<h1 style="color: #5e9ca0;"><img src="http://www.clker.com/cliparts/O/v/c/b/i/6/generic-logo-md.png" /></h1>
<h1 style="color: #5e9ca0;">Your user has been created!</h1>
<table>
<tbody>
<tr>
<th style="text-align: center;" colspan="3">Connection Info&nbsp;</th>
</tr>
<tr>
<td>user</td>
<td>&nbsp;<
<td><strong>${USER_NAME}</strong></td>
</tr>
<tr>
<td>password</td>
<td>&nbsp;</td>
<td><strong>${USER_PASS}</strong></td>
</tr>
<tr>
<td>url</td>
<td>&nbsp;</td>
<td><strong><a style="decoration:none;">access.mydomain.com/login</a></strong></td>
</tr>
</tbody>
</table>
<p><br /><strong>Enjoy!</strong></p>

EOF
}

function send-email() {
    local EMAIL_TO=$1
    local USER_NAME=$2
    local USER_PASS=$3

    local EMAIL_FROM="my-email-here@gmail.com" ## <-- YOUR GMAIL HERE
    local EMAIL_TOKEN="sqkvdloomgmcqvun" ## <-- YOUR GOOGLE APP PASSWORD HERE
    local EMAIL_SUBJECT="User created"
    local EMAIL_CONTENT=$(email-pattern "${USER_NAME}" "${USER_PASS}")

    echo "sending email to [${EMAIL_TO}] with content [${EMAIL_CONTENT}]"
    echo "${EMAIL_CONTENT}" | sendemail \
        -f  "${EMAIL_FROM}"  \
        -u  "${EMAIL_SUBJECT}"  \
        -t  "${EMAIL_TO}"  \
        -cc "${EMAIL_FROM}"  \
        -s  "smtp.gmail.com:587"  \
        -o  "message-content-type=html" \
        -o  "tls=yes"  \
        -xu "${EMAIL_FROM}"  \
        -xp "${EMAIL_TOKEN}" 

}

function email-automated-process() {

  for email in "$@"; do
    echo "Processing email [${email}]"

    local USER_NAME=$(get-username-by-email "${email}")
    local USER_PASS=$(pwgen -sn 16 1)
    
    process-user "${USER_NAME}" "${USER_PASS}"

    local  RET=$?

    if [ $RET -ne 0 ]; then
      echo "USER NOT CREATED [${USER_NAME}]!"
      return 1
    else
      echo "USER CREATED [${USER_NAME}]!"
    fi

    send-email "${email}" "${USER_NAME}" "${USER_PASS}"

  done
}

function main {
    email-automated-process "$@"
}

main "$@"

