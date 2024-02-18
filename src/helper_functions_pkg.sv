

package helper_functions_pkg;
	`include "src/defines.sv"

	task display_weights_logfile(
		string name,
		logic [`N_ROWS-1:0][`N_COLUMNS-1:0][`WIDTH-1:0] matrix,
		int n_rows,
		int n_columns);
		int file;

		file = $fopen("logs/weights.txt", "w");

		$fwrite(file, "%s = \n[", name);

		for (int i = 0; i < n_rows; i++) begin
			for (int j = 0; j < n_columns; j++) begin
				if(i==n_rows-1 && j==n_columns-1) $fwrite(file, "\t%x]\n\n", matrix[i][j]);
				else begin 
					$fwrite(file, "\t%x, ", matrix[i][j]);
				end
			end
			$fwrite(file, "\n");
		end
		$fclose(file);
	endtask


endpackage