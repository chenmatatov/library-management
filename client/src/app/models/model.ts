export interface Book {
  ID: number;               
  Title: string;            
  Author: string;          
  Category: string;         
  Description: string;
  StatusId: number;         
  StatusName?: string;      
  LocationId: number;       
  LocationName?: string;    
  PublishYear: number;      
  AvailableCopies: number;  
  CreatedAt?: Date;
}

export interface Status {
  ID: number;
  Name: string;
  Description: string;
}

export interface Location {
  ID: number;
  LocationName: string;
  Description: string;
}
