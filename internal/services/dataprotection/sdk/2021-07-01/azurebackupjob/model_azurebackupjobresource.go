package azurebackupjob

type AzureBackupJobResource struct {
	Id         *string         `json:"id,omitempty"`
	Name       *string         `json:"name,omitempty"`
	Properties *AzureBackupJob `json:"properties,omitempty"`
	SystemData *SystemData     `json:"systemData,omitempty"`
	Type       *string         `json:"type,omitempty"`
}
