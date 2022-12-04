package gapi

import (
	"context"

	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/peer"
)

type Metadata struct {
	UserAgent string
	ClientIP  string
}

const (
	userAgentHeader = "user-agent"
)

func (server *Server) extractMetadata(ctx context.Context) *Metadata {
	mtdt := &Metadata{}

	if md, ok := metadata.FromIncomingContext(ctx); ok {
		if userAgents := md.Get(userAgentHeader); len(userAgents) > 0 {
			mtdt.UserAgent = userAgents[0]
		}
		// if clientIPs := md.Get(authorityHeader); len(clientIPs) > 0 {
		// 	mtdt.ClientIP = clientIPs[0]
		// }
	}

	if peer, ok := peer.FromContext(ctx); ok {
		mtdt.ClientIP = peer.Addr.String()
	}

	return mtdt
}
