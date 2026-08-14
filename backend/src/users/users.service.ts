import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from './entities/user.entity';
import { RegisterWorkerDto, RegisterBusinessDto } from '../auth/auth.service';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
  ) {}

  async findByPhoneNumber(phoneNumber: string): Promise<User | null> {
    return this.usersRepository.findOne({
      where: { phoneNumber },
      relations: ['workerProfile', 'businessProfile'],
    });
  }

  async findByNationalId(nationalId: string): Promise<User | null> {
    return this.usersRepository.findOne({
      where: { nationalId },
    });
  }

  async findById(id: string): Promise<User | null> {
    return this.usersRepository.findOne({
      where: { id },
      relations: ['workerProfile', 'businessProfile'],
    });
  }

  async create(userData: Partial<User>): Promise<User> {
    const user = this.usersRepository.create(userData);
    return this.usersRepository.save(user);
  }

  async createWorker(registerDto: RegisterWorkerDto): Promise<User> {
    const user = this.usersRepository.create({
      fullName: registerDto.fullName,
      phoneNumber: registerDto.phoneNumber,
      email: registerDto.email,
      nationalId: registerDto.nationalId,
      profilePicture: registerDto.profilePicture,
      latitude: registerDto.latitude,
      longitude: registerDto.longitude,
      role: UserRole.WORKER,
    });
    
    const savedUser = await this.usersRepository.save(user);
    
    // Create worker profile
    // This would be handled by a separate WorkerProfile entity
    
    return savedUser;
  }

  async createBusiness(registerDto: RegisterBusinessDto): Promise<User> {
    const user = this.usersRepository.create({
      fullName: registerDto.fullName,
      phoneNumber: registerDto.phoneNumber,
      email: registerDto.email,
      nationalId: registerDto.nationalId,
      profilePicture: registerDto.profilePicture,
      latitude: registerDto.latitude,
      longitude: registerDto.longitude,
      role: UserRole.BUSINESS,
    });
    
    const savedUser = await this.usersRepository.save(user);
    
    // Create business profile
    // This would be handled by a separate BusinessProfile entity
    
    return savedUser;
  }

  async update(id: string, updateData: Partial<User>): Promise<User | null> {
    await this.usersRepository.update(id, updateData);
    return this.findById(id);
  }
}