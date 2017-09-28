<?php

require_once('./sphinxapi.php');

$Sphinx = new SphinxClient();
$Sphinx->SetServer('127.0.0.1', '9312');
$Sphinx->SetMatchMode(SPH_MATCH_ANY);
$Sphinx->SetConnectTimeout(5);
$Sphinx->SetArrayResult(true);
#return $Sphinx;

$keyword = 'doc';
//$Sphinx->SetMatchMode($keyword ? SPH_MATCH_PHRASE : SPH_MATCH_FULLSCAN);



$Sphinx->SetSortMode(SPH_SORT_EXTENDED, 'group_id asc');
$Sphinx->SetLimits(0, 10);
$Sphinx->SetFilter('id', array(3));
$result = $Sphinx->Query($keyword, 'test_andy');
print_r($result);

//$total = intval(value($result, 'total'));
//$result = value($result, 'matches');




echo "\n";
