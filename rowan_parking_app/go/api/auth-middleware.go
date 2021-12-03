package api

import (
	"encoding/json"
	"io"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

func AuthMiddleware(c *gin.Context) {
	token, ok := c.Request.Header["Authorization"]
	if !ok {
		c.IndentedJSON(http.StatusUnauthorized, "No Access Token Provided")
		return
	}

	if len(token) == 0 {
		c.IndentedJSON(http.StatusUnauthorized, "Misformatted Token")
		return
	}

	httpResp, err := http.Get("https://oauth2.googleapis.com/tokeninfo?id_token=" + token[0])
	if err != nil {
		c.IndentedJSON(http.StatusGatewayTimeout, err)
		return
	}
	defer httpResp.Body.Close()

	respData, err := io.ReadAll(httpResp.Body)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	resp := struct {
		err   string `json:"error"`
		exp   int64
		email string
	}{}
	err = json.Unmarshal(respData, &resp)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	if resp.err != "" {
		c.IndentedJSON(http.StatusUnauthorized, err)
		return
	}

	if time.Unix(resp.exp, 0).Before(time.Now()) {
		c.IndentedJSON(http.StatusUnauthorized, err)
		return
	}
}
