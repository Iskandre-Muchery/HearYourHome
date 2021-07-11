import { IsEmail, IsString, MaxLength, MinLength } from 'class-validator';

export class SessionRecoverPasswordDto {
    @IsString()
    token!: string;

    @IsString()
    @MinLength(8)
    @MaxLength(64)
    password!: string;
}

export class SessionForgotPasswordDto {
    @IsEmail()
    email!: string;
}

export interface Session {
    id: string;
    createdAt: string;
    email: string;
    issued: number;
    expires: number;
}
  
export type PartialSession = Omit<Session, "issued" | "expires">;
  
export interface EncodeResult {
    token: string,
    expires: number,
    issued: number
}
  
export type DecodeResult =
    |   {
            type: "valid";
            session: Session;
        }
    |   {
            type: "integrity-error";
        }
    |   {
            type: "invalid-token";
        };
  
export type ExpirationStatus = "expired" | "active" | "grace";