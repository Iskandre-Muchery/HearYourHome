import { encode, decode, TAlgorithm } from 'jwt-simple';
import { DecodeResult, EncodeResult, ExpirationStatus, PartialSession, Session } from './sessionTypes'

export function encodeSession(secretKey: string, partialSession: PartialSession): EncodeResult {
  const algorithm: TAlgorithm = "HS512";
  const issued = Date.now();
  const fifteenMinutesInMs = 15 * 60 * 1000;
  const expires = issued + fifteenMinutesInMs;
  const session: Session = {
    ...partialSession,
    issued: issued,
    expires: expires,
  };

  return {
    token: encode(session, secretKey, algorithm),
    issued: issued,
    expires: expires
  }
}

export function decodeSession(secretKey: string, tokenString: string): DecodeResult {
    const algorithm: TAlgorithm = "HS512";
    let result: Session;

    try {
        result = decode(tokenString, secretKey, false, algorithm);
    } catch (_e) {
        const e: Error = _e;
        
        if (e.message === "No Token supplied" || e.message === "Not enough or too many segments") {
            return {
                type: "invalid-token"
            };
        }

        if (e.message === "Signature verification failed" || e.message === "Algorithm not supported") {
            return {
                type: "integrity-error"
            };
        }

        if (e.message.indexOf("Unexpected token") === 0) {
            return {
                type: "invalid-token"
            };
        }

        throw e;
    }
    
    return {
        type: "valid",
        session: result
    }
}

export function checkExpirationStatus(token: Session): ExpirationStatus {
    const now = Date.now();

    if (token.expires > now) return "active";

    const threeHoursInMs = 3 * 60 * 60 * 1000;
    const threeHoursAfterExpiration = token.expires + threeHoursInMs;

    if (threeHoursInMs > now) return "grace";

    return "expired";

}