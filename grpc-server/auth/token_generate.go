package auth

import (
	"time"

	"github.com/djsmk123/server/token"
)

func CreateToken(tokenMaker token.Maker, username string, userId int64, duration time.Duration) (string, error) {
	accesstoken, err := tokenMaker.CreateToken(userId, username, duration)
	if err != nil {
		return "", err
	}
	return accesstoken, nil

}
