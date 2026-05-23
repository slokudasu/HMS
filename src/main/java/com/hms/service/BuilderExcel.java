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

import com.hms.entity.Builder;


@Service
public class BuilderExcel {

    public ByteArrayInputStream export(List<Builder> members) throws IOException {
        String[] columns = {"Builder Name", "Amount", "Status" ,"Construction Plot No","Updated Date"};

        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet("Builders");

            // Header
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
            }

            // Data rows
            int rowIdx = 1;
            for (Builder mem : members) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(mem.getBuilderName());
                row.createCell(1).setCellValue(mem.getAmount());
                row.createCell(2).setCellValue(mem.getStatus());
                row.createCell(3).setCellValue(mem.getPlotNumber());              
                row.createCell(4).setCellValue(mem.getCreationDateTime().toString());
            }

            workbook.write(out);
            return new ByteArrayInputStream(out.toByteArray());
        }
    }
}