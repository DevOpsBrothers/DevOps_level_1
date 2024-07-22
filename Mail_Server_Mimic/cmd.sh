cat msg.txt | msmtp \
--auth=off --tls=off \
    --host smtp4dev \
    --port 25 \
    --user '' \
    --read-envelope-from \
    --read-recipients