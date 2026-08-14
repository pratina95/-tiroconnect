import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import { User, UserRole } from '../users/entities/user.entity';
import { FirebaseAdminService } from '../firebase/firebase-admin.service';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
    private firebaseAdmin: FirebaseAdminService,
  ) {}

  async validateFirebaseToken(idToken: string): Promise<User> {
    try {
      const decodedToken = await this.firebaseAdmin.verifyIdToken(idToken);
      const firebaseUser = await this.firebaseAdmin.getUser(decodedToken.uid);

      if (!firebaseUser.phoneNumber) {
        throw new UnauthorizedException('Firebase user does not have a phone number');
      }

      let user = await this.usersService.findByPhoneNumber(firebaseUser.phoneNumber);
      
      if (!user) {
        // Create new user
        user = await this.usersService.create({
          fullName: firebaseUser.displayName || 'New User',
          phoneNumber: firebaseUser.phoneNumber,
          email: firebaseUser.email,
          role: UserRole.CUSTOMER,
        });
      }
      
      return user;
    } catch (error) {
      throw new UnauthorizedException('Invalid Firebase token');
    }
  }

  async registerCustomer(registerDto: RegisterCustomerDto): Promise<User> {
    // Check if phone number already exists
    const existingUser = await this.usersService.findByPhoneNumber(registerDto.phoneNumber);
    if (existingUser) {
      throw new ConflictException('Phone number already registered');
    }
    
    // Check if national ID already exists
    if (registerDto.nationalId) {
      const existingNationalId = await this.usersService.findByNationalId(registerDto.nationalId);
      if (existingNationalId) {
        throw new ConflictException('National ID already registered');
      }
    }
    
    return this.usersService.create({
      ...registerDto,
      role: UserRole.CUSTOMER,
    });
  }

  async registerWorker(registerDto: RegisterWorkerDto): Promise<User> {
    // Check if phone number already exists
    const existingUser = await this.usersService.findByPhoneNumber(registerDto.phoneNumber);
    if (existingUser) {
      throw new ConflictException('Phone number already registered');
    }
    
    // Check if national ID already exists
    if (registerDto.nationalId) {
      const existingNationalId = await this.usersService.findByNationalId(registerDto.nationalId);
      if (existingNationalId) {
        throw new ConflictException('National ID already registered');
      }
    }
    
    return this.usersService.createWorker(registerDto);
  }

  async registerBusiness(registerDto: RegisterBusinessDto): Promise<User> {
    // Check if phone number already exists
    const existingUser = await this.usersService.findByPhoneNumber(registerDto.phoneNumber);
    if (existingUser) {
      throw new ConflictException('Phone number already registered');
    }
    
    // Check if national ID already exists
    if (registerDto.nationalId) {
      const existingNationalId = await this.usersService.findByNationalId(registerDto.nationalId);
      if (existingNationalId) {
        throw new ConflictException('National ID already registered');
      }
    }
    
    return this.usersService.createBusiness(registerDto);
  }

  async login(user: User) {
    const payload = {
      sub: user.id,
      phoneNumber: user.phoneNumber,
      role: user.role,
    };
    
    return {
      access_token: this.jwtService.sign(payload),
      user,
    };
  }
}

// DTOs
export class RegisterCustomerDto {
  fullName: string;
  phoneNumber: string;
  email?: string;
  nationalId?: string;
  profilePicture?: string;
  latitude?: number;
  longitude?: number;
}

export class RegisterWorkerDto {
  fullName: string;
  phoneNumber: string;
  email?: string;
  nationalId?: string;
  profilePicture?: string;
  latitude?: number;
  longitude?: number;
  skills: string[];
  yearsOfExperience: number;
  certificates: string[];
  portfolioImages: string[];
  tradeLicense?: string;
  hourlyRate: number;
  workingRadius: number;
  languagesSpoken: string[];
}

export class RegisterBusinessDto {
  fullName: string;
  phoneNumber: string;
  email?: string;
  nationalId?: string;
  profilePicture?: string;
  latitude?: number;
  longitude?: number;
  companyName: string;
  companyLogo?: string;
  registrationNumber?: string;
  address?: string;
}