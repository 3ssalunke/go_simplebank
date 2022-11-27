package util

import (
	"testing"

	"github.com/stretchr/testify/require"
	"golang.org/x/crypto/bcrypt"
)

func TestPassword(t *testing.T) {
	password := RandomString(6)

	hashedPassword1, err := HashPassword(password)
	require.NoError(t, err)
	require.NotEmpty(t, hashedPassword1)
	require.NoError(t, CheckPassword(hashedPassword1, password))

	hashedPassword2, err := HashPassword(password)
	require.NoError(t, err)
	require.NotEmpty(t, hashedPassword1)
	require.NoError(t, CheckPassword(hashedPassword1, password))

	require.NotEqual(t, hashedPassword1, hashedPassword2)

	wrongPassword := RandomString(6)
	require.EqualError(t, CheckPassword(hashedPassword1, wrongPassword), bcrypt.ErrMismatchedHashAndPassword.Error())
}
