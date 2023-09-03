package gapi

import (
	"fmt"
	"strings"
)

func methodRequiresAuthentication(fullMethod string) bool {
	m := extractMethodName(fullMethod)
	m = strings.ToLower(m)
	fmt.Println(m)

	// Define a list of methods that require authentication.

	NonAuthRequiredMethods := []string{
		"login",
		"signup",
	}

	// Check if the requested method is in the list.
	for _, method := range NonAuthRequiredMethods {
		if m == method {
			return false
		}
	}

	return true
}

func extractMethodName(fullMethod string) string {
	// Define the prefix to remove
	prefix := "/pb.GrpcServerService/"

	// Use TrimPrefix to remove the prefix from the full method name
	method := strings.TrimPrefix(fullMethod, prefix)

	return method
}
