function manual-update
  awsume cazoo-prod -o default
  aws lambda invoke --function-name dev-cazoo-customer-auth-manualEmailUpdate \
  --payload '{"oldEmail": "$argv[1]", "newEmail": "$argv[2]" }' response.json
end
