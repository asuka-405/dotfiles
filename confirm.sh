confirm() {
    local question="$1"
    local yes_answer="$2"
    local no_answer="$3"
    local default_answer="$4"
    local response

    while true; do
        # Prompt the user
        read -p "$question [$default_answer]: " response

        # Set default response if none provided
        if [ -z "$response" ]; then
            response="$default_answer"
        fi

        # Determine the action based on the response
        case $response in
            [Yy]* )
                echo "$yes_answer"
                return 0
                ;;
            [Nn]* )
                echo "$no_answer"
                return 1
                ;;
            * )
                echo "Invalid response. Please answer with $yes_answer or $no_answer."
                ;;
        esac
    done
}
