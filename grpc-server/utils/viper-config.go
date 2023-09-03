package utils

import (
	"time"

	"github.com/spf13/viper"
)

type ViperConfig struct {
	DBNAME              string        `mapstructure:"DB_NAME"`
	DBSource            string        `mapstructure:"DB_SOURCE"`
	MIGRATIONURL        string        `mapstructure:"MIGRATION_URL"`
	RPCSERVERADDRESS    string        `mapstructure:"RPC_SERVER_ADDRESS"`
	TokkenStructureKey  string        `mapstructure:"TOKEN_SYMMETRIC_KEY"`
	AccessTokenDuration time.Duration `mapstructure:"ACCESS_TOKEN_DURATION"`
	GINSERVERADDRESS    string        `mapstructure:"GIN_SERVER_ADDRESS"`
	GINMODE             string        `mapstructure:"GIN_MODE"`
}

func LoadConfiguration(path string) (config ViperConfig, err error) {
	viper.AddConfigPath(path)
	viper.SetConfigName("app")
	viper.SetConfigType("env")
	viper.AutomaticEnv()

	err = viper.ReadInConfig()

	if err != nil {
		return
	}
	err = viper.Unmarshal(&config)
	return

}
