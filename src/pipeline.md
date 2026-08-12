# Signing Pipeline

NexSign uses a multi‑stage GitHub Actions pipeline:

1. Generate valid P12 from private key + Apple certificate  
2. Validate P12 identity  
3. Generate binary CMS mobileprovision  
4. Build cert pack  
5. Sign IPA  
6. Deploy NexSign website  
7. Commit website source files  

This ensures a smooth, automated signing experience.
