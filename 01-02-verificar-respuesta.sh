#! /bin/sh
echo "Verificar que el servidor responda"

echo "curl a: http://127.0.0.1:8080"
curl http://127.0.0.1:8080
echo ""
echo "curl a: http://127.0.0.1:8080/healt "
curl http://127.0.0.1:8080/healthcd 
echo ""

