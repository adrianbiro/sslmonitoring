package main

import (
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"flag"
	"fmt"
	"math"
	"net"
	"os"
	"time"
)

// Cert json result
type Cert struct {
	CommonName         string    `json:"cn"`
	NotAfter           time.Time `json:"not_after"`
	NotBefore          time.Time `json:"not_before"`
	DNSNames           []string  `json:"dns_names"`
	SignatureAlgorithm string    `json:"signature_algorithm"`
	IssuerCommonName   string    `json:"issuer"`
	Organizations      []string  `json:"organizations"`
	ExpireAfterSec     float64   `json:"expiration_sec"`
	ExpireAfterDays    float64   `json:"expiration_days"`
}

// VerCertChains verify certificate
func VerCertChains(addr string, timeoutSecond time.Duration) ([][]*x509.Certificate, error) {
	conn, err := tls.DialWithDialer(&net.Dialer{Timeout: timeoutSecond * time.Second}, "tcp", addr, nil)
	if err != nil {
		return nil, err
	}
	defer conn.Close()

	chains := conn.ConnectionState().VerifiedChains
	return chains, nil
}

// ParseCert from address and return Cert struct
func ParseCert(addr string, timeoutSecond int) (*Cert, error) {
	chains, err := VerCertChains(addr, time.Duration(timeoutSecond))
	if err != nil {
		return nil, err
	}

	var cert *Cert
	for _, chain := range chains {
		for _, crt := range chain {
			if !crt.IsCA {
				cert = &Cert{
					CommonName:         crt.Subject.CommonName,
					NotAfter:           crt.NotAfter,
					NotBefore:          crt.NotBefore,
					DNSNames:           crt.DNSNames,
					SignatureAlgorithm: crt.SignatureAlgorithm.String(),
					IssuerCommonName:   crt.Issuer.CommonName,
					Organizations:      crt.Issuer.Organization,
					ExpireAfterSec:     time.Until(crt.NotAfter).Seconds(),
					ExpireAfterDays:    math.Round(time.Until(crt.NotAfter).Seconds() / 86400),
				}
			}
		}
	}
	return cert, err
}

// Tojson marshal struct to json
func (cert *Cert) Tojson() string {
	b, _ := json.Marshal(cert)
	return string(b)
}

func main() {
	var (
		port string = ":443"
		iad  string
		url  string
		jobj map[string]interface{}
	)

	fullJSON := flag.Bool("all", false, "Get full json string.")
	flag.Parse()
	if flag.NArg() == 0 {
		flag.Usage()
		os.Exit(1)

	}

	url = flag.Arg(0) // TODO make all flag works and fix ordering for all flags
	//boo := flag.Args()
	//	fmt.Println(boo)
	//os.Exit(1)

	iad = fmt.Sprintf("%v%v%v", "www.", url, port)

	raw, err := ParseCert(iad, 10)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	all := raw.Tojson()

	if *fullJSON {
		fmt.Println(all)
		os.Exit(0)

	}
	json.Unmarshal([]byte(all), &jobj)
	fmt.Println(jobj["expiration_days"])

}
