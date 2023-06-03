declare -A > /dev/null

INIT_WEIGHT=1000
MULTIPLIER=100
DELTA=1

prev_3ch_phone=''
prev_oth_phone=''
full_3ch_weight=${INIT_WEIGHT}
full_oth_weight=${INIT_WEIGHT}

while [[ $# -gt 0 ]]
do
    case $1 in
        -p|--phrases)
            phrases="$2"
            shift
            shift
            ;;
        -c|--char)
            chars="$2"
            shift
            shift
            ;;
        -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

cat ${phrases} | while read line
do
    word=$(echo $line | awk '{print $1}' | tr -d '\r' | tr -d '\n')
    code=$(echo $line | awk '{print $2}' | tr -d '\r' | tr -d '\n')
    if [ ${#word} -eq 3  ] && [ "${word}" != "好吗？" ] ||  [ "${word:0:3}" = "季姬寂" ] || [ "${word}" = "你好吗？" ]
    then
        phone=${code:0:3}
        if [ "${phone}" != "${prev_3ch_phone}" ]
        then
            full_3ch_weight=${INIT_WEIGHT}
        else
            full_3ch_weight=$(( ${full_3ch_weight} - ${DELTA} ))
        fi
        full_weight=${full_3ch_weight}
        max=3
    else
        phone=${code:0:4}
        if [ "${phone}" != "${prev_oth_phone}" ]
        then
            full_oth_weight=${INIT_WEIGHT}
        else
            full_oth_weight=$(( ${full_oth_weight} - ${DELTA} ))
        fi
        full_weight=${full_oth_weight}
        max=2
    fi

    stroke=""
    for (( i=0; i<${max}; i++ ))
    do
        ch=${word:$i:1}
        ch_code=$(grep $ch $chars | awk '{print $2}')
        if [ -z "${ch_code}" ]
        then
            echo "Character ${ch} not found!"
            exit 1
        fi
        stroke="${stroke}${ch_code:2:1}"
    done

    weight=$(( ${full_weight} - (${#code} - ${#phone}) * ${MULTIPLIER} ))
    echo -e "${word}\t${phone}\t${stroke}\t${weight}"

    if [ ${#word} -eq 3 ] && [ "${word}" != "好吗？" ] ||  [ "${word:0:3}" = "季姬寂" ] || [ "${word}" = "你好吗？" ]
    then
        prev_3ch_phone=${phone}
    else
        prev_oth_phone=${phone}
    fi
done
