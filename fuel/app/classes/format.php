<?php

class Format extends Fuel\COre\Format
{

	public function to_csv($data = null, $delimiter = null, $exclude_header = false)
	{
		// csv format settings
		$newline = \Config::get('format.csv.export.newline', \Config::get('format.csv.newline', "\n"));
		$delimiter or $delimiter = \Config::get('format.csv.export.delimiter', \Config::get('format.csv.delimiter', ','));
		$enclosure = \Config::get('format.csv.export.enclosure', \Config::get('format.csv.enclosure', '"'));
		$escape = \Config::get('format.csv.export.escape', \Config::get('format.csv.escape', '"'));

		// escape function
		$escaper = function($items) use($enclosure, $escape) {
			return array_map(function($item) use($enclosure, $escape){
				return str_replace($enclosure, $escape.$enclosure, $item);
			}, $items);
		};

		if ($data === null)
		{
			$data = $this->_data;
		}

		if (is_object($data) and ! $data instanceof \Iterator)
		{
			$data = $this->to_array($data);
		}

		// Multi-dimensional array
		if (is_array($data) and \Arr::is_multi($data))
		{
			$data = array_values($data);

			if (\Arr::is_assoc($data[0]))
			{
				$headings = array_keys($data[0]);
			}
			else
			{
				$headings = array_shift($data);
			}
		}
		// Single array
		else
		{
			$headings = array_keys((array) $data);
			$data = array($data);
		}

		$output = $enclosure.implode($enclosure.$delimiter.$enclosure, $escaper($headings)).$enclosure.$newline;
		if ($exclude_header)
		{
			$output = '';
		}

		foreach ($data as $row)
		{
			$output .= $enclosure.implode($enclosure.$delimiter.$enclosure, $escaper((array) $row)).$enclosure.$newline;
		}

		return mb_convert_encoding(rtrim($output, $newline), 'SJIS-win', 'UTF-8');
	}

}
