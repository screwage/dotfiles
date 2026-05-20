if type aws_completer &> /dev/null; then
    complete -C '/usr/bin/aws_completer' aws
fi

if type aws &> /dev/null; then
    ec2ssh() {
        local selected=$(aws ec2 describe-instances \
            --filters "Name=instance-state-name,Values=running" \
            --query 'Reservations[*].Instances[*].[PublicIpAddress,Tags[?Key==`Name`].Value|[0]]' \
            --output text \
            | fzf --prompt="EC2> ")

        [[ -z "$selected" ]] && return 1

        local ip=$(echo "$selected" | awk '{print $1}')
        ssh ec2-user@"$ip"
}
fi

ssh-add ~/.ssh/ec2-tutorial.pem 2>/dev/null
