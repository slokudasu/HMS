package com.hms.service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import com.hms.entity.Member;


@Service
public class MemberExcelService {

    public ByteArrayInputStream export(List<Member> members) throws IOException {
        String[] columns = {"Name", "Mobile Number", "Member Type" ,"Membership","Membership Amount"};

        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet("Members");

            // Header
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
            }

            // Data rows
            int rowIdx = 1;
            for (Member mem : members) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(mem.getFirstName()+" "+mem.getLastName());
                row.createCell(1).setCellValue(mem.getMobileNumber());
                row.createCell(2).setCellValue(mem.getMemberType());
                if(mem.isMemberShipFlag()) {
                	row.createCell(3).setCellValue("Yes");
                } else {
                	row.createCell(3).setCellValue("No");
                }                
                row.createCell(4).setCellValue(mem.getMemberShipAmount());
            }

            workbook.write(out);
            return new ByteArrayInputStream(out.toByteArray());
        }
    }
}