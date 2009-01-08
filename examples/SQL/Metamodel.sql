CREATE TABLE AllowedRange (
	-- AllowedRange is where ValueRestriction allows ValueRange and ValueRestriction has ValueRestrictionId,
	ValueRestrictionId                      int NOT NULL,
	-- AllowedRange is where ValueRestriction allows ValueRange and maybe ValueRange has minimum-Bound and Bound has Value,
	ValueRangeMinimumBoundValue             varchar(256) NULL,
	-- AllowedRange is where ValueRestriction allows ValueRange and maybe ValueRange has minimum-Bound and Bound is inclusive,
	ValueRangeMinimumBoundIsInclusive       bit NULL,
	-- AllowedRange is where ValueRestriction allows ValueRange and maybe ValueRange has maximum-Bound and Bound has Value,
	ValueRangeMaximumBoundValue             varchar(256) NULL,
	-- AllowedRange is where ValueRestriction allows ValueRange and maybe ValueRange has maximum-Bound and Bound is inclusive,
	ValueRangeMaximumBoundIsInclusive       bit NULL,
	UNIQUE(ValueRestrictionId, ValueRangeMinimumBoundValue, ValueRangeMinimumBoundIsInclusive, ValueRangeMaximumBoundValue, ValueRangeMaximumBoundIsInclusive)
)
GO

CREATE TABLE [Constraint] (
	-- Constraint has ConstraintId,
	ConstraintId                            int IDENTITY NOT NULL,
	-- maybe Name is of Constraint,
	Name                                    varchar(64) NULL,
	-- maybe Constraint requires Enforcement,
	Enforcement                             varchar(16) NULL,
	-- maybe Vocabulary contains Constraint and Vocabulary is called Name,
	VocabularyName                          varchar(64) NULL,
	-- maybe RingConstraint is a subtype of Constraint and maybe Role is of RingConstraint and Role is where FactType has Ordinal role played by Concept and FactType has FactTypeId,
	RingConstraintRoleFactTypeId            int NULL,
	-- maybe RingConstraint is a subtype of Constraint and maybe Role is of RingConstraint and Role is where FactType has Ordinal role played by Concept,
	RingConstraintRoleOrdinal               int NULL,
	-- maybe RingConstraint is a subtype of Constraint and maybe Role is of RingConstraint and Role is where FactType has Ordinal role played by Concept and Feature is called Name,
	RingConstraintRoleConceptName           varchar(64) NULL,
	-- maybe RingConstraint is a subtype of Constraint and maybe Role is of RingConstraint and Role is where FactType has Ordinal role played by Concept and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	RingConstraintRoleConceptVocabularyName varchar(64) NULL,
	-- maybe RingConstraint is a subtype of Constraint and maybe other-Role is of RingConstraint and Role is where FactType has Ordinal role played by Concept and FactType has FactTypeId,
	RingConstraintOtherRoleFactTypeId       int NULL,
	-- maybe RingConstraint is a subtype of Constraint and maybe other-Role is of RingConstraint and Role is where FactType has Ordinal role played by Concept,
	RingConstraintOtherRoleOrdinal          int NULL,
	-- maybe RingConstraint is a subtype of Constraint and maybe other-Role is of RingConstraint and Role is where FactType has Ordinal role played by Concept and Feature is called Name,
	RingConstraintOtherRoleConceptName      varchar(64) NULL,
	-- maybe RingConstraint is a subtype of Constraint and maybe other-Role is of RingConstraint and Role is where FactType has Ordinal role played by Concept and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	RingConstraintOtherRoleConceptVocabularyName varchar(64) NULL,
	-- maybe RingConstraint is a subtype of Constraint and RingConstraint is of RingType,
	RingConstraintRingType                  varchar NULL,
	-- maybe PresenceConstraint is a subtype of Constraint and PresenceConstraint covers RoleSequence and RoleSequence has RoleSequenceId,
	PresenceConstraintRoleSequenceId        int NULL,
	-- maybe PresenceConstraint is a subtype of Constraint and maybe PresenceConstraint has max-Frequency,
	PresenceConstraintMaxFrequency          int NULL CHECK(PresenceConstraintMaxFrequency >= 1),
	-- maybe PresenceConstraint is a subtype of Constraint and maybe PresenceConstraint has min-Frequency,
	PresenceConstraintMinFrequency          int NULL CHECK(PresenceConstraintMinFrequency >= 2),
	-- maybe PresenceConstraint is a subtype of Constraint and PresenceConstraint is preferred identifier,
	PresenceConstraintIsPreferredIdentifier bit NULL,
	-- maybe PresenceConstraint is a subtype of Constraint and PresenceConstraint is mandatory,
	PresenceConstraintIsMandatory           bit NULL,
	-- maybe SetConstraint is a subtype of Constraint and maybe SetComparisonConstraint is a subtype of SetConstraint and maybe SetExclusionConstraint is a subtype of SetComparisonConstraint and SetExclusionConstraint is mandatory,
	SetExclusionConstraintIsMandatory       bit NULL,
	-- maybe SetConstraint is a subtype of Constraint and maybe SubsetConstraint is a subtype of SetConstraint and SubsetConstraint covers superset-RoleSequence and RoleSequence has RoleSequenceId,
	SubsetConstraintSupersetRoleSequenceId  int NULL,
	-- maybe SetConstraint is a subtype of Constraint and maybe SubsetConstraint is a subtype of SetConstraint and SubsetConstraint covers subset-RoleSequence and RoleSequence has RoleSequenceId,
	SubsetConstraintSubsetRoleSequenceId    int NULL,
	PRIMARY KEY(ConstraintId)
)
GO

CREATE TABLE Correspondence (
	-- Correspondence is where in Import imported-Feature corresponds to local-Feature and Import is where Vocabulary imports imported-Vocabulary and Vocabulary is called Name,
	ImportVocabularyName                    varchar(64) NOT NULL,
	-- Correspondence is where in Import imported-Feature corresponds to local-Feature and Import is where Vocabulary imports imported-Vocabulary and Vocabulary is called Name,
	ImportImportedVocabularyName            varchar(64) NOT NULL,
	-- Correspondence is where in Import imported-Feature corresponds to local-Feature and Feature is called Name,
	ImportedFeatureName                     varchar(64) NOT NULL,
	-- Correspondence is where in Import imported-Feature corresponds to local-Feature and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	ImportedFeatureVocabularyName           varchar(64) NULL,
	-- Correspondence is where in Import imported-Feature corresponds to local-Feature and Feature is called Name,
	LocalFeatureName                        varchar(64) NOT NULL,
	-- Correspondence is where in Import imported-Feature corresponds to local-Feature and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	LocalFeatureVocabularyName              varchar(64) NULL,
	UNIQUE(ImportVocabularyName, ImportImportedVocabularyName, ImportedFeatureName, ImportedFeatureVocabularyName)
)
GO

CREATE TABLE Derivation (
	-- Derivation is where DerivedUnit is derived from BaseUnit and Unit has UnitId,
	DerivedUnitId                           int NOT NULL,
	-- Derivation is where DerivedUnit is derived from BaseUnit and Unit has UnitId,
	BaseUnitId                              int NOT NULL,
	-- maybe Derivation has Exponent,
	Exponent                                int NULL,
	PRIMARY KEY(DerivedUnitId, BaseUnitId)
)
GO

CREATE TABLE Fact (
	-- Fact has FactId,
	FactId                                  int IDENTITY NOT NULL,
	-- Fact is of FactType and FactType has FactTypeId,
	FactTypeId                              int NOT NULL,
	-- Population includes Fact and Population has Name,
	PopulationName                          varchar(64) NOT NULL,
	-- Population includes Fact and maybe Vocabulary includes Population and Vocabulary is called Name,
	PopulationVocabularyName                varchar(64) NULL,
	PRIMARY KEY(FactId)
)
GO

CREATE TABLE FactType (
	-- FactType has FactTypeId,
	FactTypeId                              int IDENTITY NOT NULL,
	-- maybe EntityType nests FactType and Feature is called Name,
	EntityTypeName                          varchar(64) NULL,
	-- maybe EntityType nests FactType and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	EntityTypeVocabularyName                varchar(64) NULL,
	-- maybe TypeInheritance is a subtype of FactType and TypeInheritance is where Subtype is subtype of Supertype and Feature is called Name,
	TypeInheritanceSubtypeName              varchar(64) NULL,
	-- maybe TypeInheritance is a subtype of FactType and TypeInheritance is where Subtype is subtype of Supertype and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	TypeInheritanceSubtypeVocabularyName    varchar(64) NULL,
	-- maybe TypeInheritance is a subtype of FactType and TypeInheritance is where Subtype is subtype of Supertype and Feature is called Name,
	TypeInheritanceSupertypeName            varchar(64) NULL,
	-- maybe TypeInheritance is a subtype of FactType and TypeInheritance is where Subtype is subtype of Supertype and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	TypeInheritanceSupertypeVocabularyName  varchar(64) NULL,
	-- maybe TypeInheritance is a subtype of FactType and TypeInheritance provides identification,
	TypeInheritanceProvidesIdentification   bit NULL,
	PRIMARY KEY(FactTypeId)
)
GO

CREATE TABLE Feature (
	-- Feature is called Name,
	Name                                    varchar(64) NOT NULL,
	-- maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	VocabularyName                          varchar(64) NULL,
	-- maybe Concept is a subtype of Feature and Concept is independent,
	ConceptIsIndependent                    bit NULL,
	-- maybe Concept is a subtype of Feature and Concept is personal,
	ConceptIsPersonal                       bit NULL,
	-- maybe Concept is a subtype of Feature and maybe ValueType is a subtype of Concept and maybe ValueType is subtype of Supertype and Feature is called Name,
	ValueTypeSupertypeName                  varchar(64) NULL,
	-- maybe Concept is a subtype of Feature and maybe ValueType is a subtype of Concept and maybe ValueType is subtype of Supertype and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	ValueTypeSupertypeVocabularyName        varchar(64) NULL,
	-- maybe Concept is a subtype of Feature and maybe ValueType is a subtype of Concept and maybe ValueType has Length,
	ValueTypeLength                         int NULL,
	-- maybe Concept is a subtype of Feature and maybe ValueType is a subtype of Concept and maybe ValueType has Scale,
	ValueTypeScale                          int NULL,
	-- maybe Concept is a subtype of Feature and maybe ValueType is a subtype of Concept and maybe ValueType has ValueRestriction and ValueRestriction has ValueRestrictionId,
	ValueTypeValueRestrictionId             int NULL,
	-- maybe Concept is a subtype of Feature and maybe ValueType is a subtype of Concept and maybe ValueType is of Unit and Unit has UnitId,
	ValueTypeUnitId                         int NULL,
	UNIQUE(Name, VocabularyName),
	FOREIGN KEY (ValueTypeSupertypeName, ValueTypeSupertypeVocabularyName) REFERENCES Feature (Name, VocabularyName)
)
GO

CREATE TABLE Instance (
	-- Instance has InstanceId,
	InstanceId                              int IDENTITY NOT NULL,
	-- maybe Instance has Value,
	Value                                   varchar(256) NULL,
	-- Instance is of Concept and Feature is called Name,
	ConceptName                             varchar(64) NOT NULL,
	-- Instance is of Concept and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	ConceptVocabularyName                   varchar(64) NULL,
	-- Population includes Instance and Population has Name,
	PopulationName                          varchar(64) NOT NULL,
	-- Population includes Instance and maybe Vocabulary includes Population and Vocabulary is called Name,
	PopulationVocabularyName                varchar(64) NULL,
	PRIMARY KEY(InstanceId),
	FOREIGN KEY (ConceptName, ConceptVocabularyName) REFERENCES Feature (Name, VocabularyName)
)
GO

CREATE TABLE JoinPath (
	-- JoinPath is where RoleRef has JoinStep path and RoleRef is where RoleSequence in Ordinal position includes Role and RoleSequence has RoleSequenceId,
	RoleRefRoleSequenceId                   int NOT NULL,
	-- JoinPath is where RoleRef has JoinStep path and RoleRef is where RoleSequence in Ordinal position includes Role,
	RoleRefOrdinal                          int NOT NULL,
	-- JoinPath is where RoleRef has JoinStep path,
	JoinStep                                int NOT NULL,
	-- JoinPath has input-Role and Role is where FactType has Ordinal role played by Concept and FactType has FactTypeId,
	InputRoleFactTypeId                     int NOT NULL,
	-- JoinPath has input-Role and Role is where FactType has Ordinal role played by Concept,
	InputRoleOrdinal                        int NOT NULL,
	-- JoinPath has input-Role and Role is where FactType has Ordinal role played by Concept and Feature is called Name,
	InputRoleConceptName                    varchar(64) NOT NULL,
	-- JoinPath has input-Role and Role is where FactType has Ordinal role played by Concept and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	InputRoleConceptVocabularyName          varchar(64) NULL,
	-- JoinPath has output-Role and Role is where FactType has Ordinal role played by Concept and FactType has FactTypeId,
	OutputRoleFactTypeId                    int NOT NULL,
	-- JoinPath has output-Role and Role is where FactType has Ordinal role played by Concept,
	OutputRoleOrdinal                       int NOT NULL,
	-- JoinPath has output-Role and Role is where FactType has Ordinal role played by Concept and Feature is called Name,
	OutputRoleConceptName                   varchar(64) NOT NULL,
	-- JoinPath has output-Role and Role is where FactType has Ordinal role played by Concept and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	OutputRoleConceptVocabularyName         varchar(64) NULL,
	-- maybe JoinPath traverses Concept and Feature is called Name,
	ConceptName                             varchar(64) NULL,
	-- maybe JoinPath traverses Concept and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	ConceptVocabularyName                   varchar(64) NULL,
	PRIMARY KEY(RoleRefRoleSequenceId, RoleRefOrdinal, JoinStep),
	FOREIGN KEY (ConceptName, ConceptVocabularyName) REFERENCES Feature (Name, VocabularyName)
)
GO

CREATE TABLE Reading (
	-- FactType has Reading and FactType has FactTypeId,
	FactTypeId                              int NOT NULL,
	-- Reading has Text,
	Text                                    varchar(256) NOT NULL,
	-- Reading is in RoleSequence and RoleSequence has RoleSequenceId,
	RoleSequenceId                          int NOT NULL,
	-- Reading is in Ordinal position,
	Ordinal                                 int NOT NULL,
	PRIMARY KEY(FactTypeId, Ordinal),
	FOREIGN KEY (FactTypeId) REFERENCES FactType (FactTypeId)
)
GO

CREATE TABLE Role (
	-- Role is where FactType has Ordinal role played by Concept and FactType has FactTypeId,
	FactTypeId                              int NOT NULL,
	-- Role is where FactType has Ordinal role played by Concept,
	Ordinal                                 int NOT NULL,
	-- Role is where FactType has Ordinal role played by Concept and Feature is called Name,
	ConceptName                             varchar(64) NOT NULL,
	-- Role is where FactType has Ordinal role played by Concept and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	ConceptVocabularyName                   varchar(64) NULL,
	-- maybe Role has role-Name,
	RoleName                                varchar(64) NULL,
	-- maybe Role has role-ValueRestriction and ValueRestriction has ValueRestrictionId,
	RoleValueRestrictionId                  int NULL,
	UNIQUE(FactTypeId, Ordinal, ConceptName, ConceptVocabularyName),
	FOREIGN KEY (FactTypeId) REFERENCES FactType (FactTypeId),
	FOREIGN KEY (ConceptName, ConceptVocabularyName) REFERENCES Feature (Name, VocabularyName)
)
GO

CREATE TABLE RoleRef (
	-- RoleRef is where RoleSequence in Ordinal position includes Role and RoleSequence has RoleSequenceId,
	RoleSequenceId                          int NOT NULL,
	-- RoleRef is where RoleSequence in Ordinal position includes Role,
	Ordinal                                 int NOT NULL,
	-- RoleRef is where RoleSequence in Ordinal position includes Role and Role is where FactType has Ordinal role played by Concept and FactType has FactTypeId,
	RoleFactTypeId                          int NOT NULL,
	-- RoleRef is where RoleSequence in Ordinal position includes Role and Role is where FactType has Ordinal role played by Concept,
	RoleOrdinal                             int NOT NULL,
	-- RoleRef is where RoleSequence in Ordinal position includes Role and Role is where FactType has Ordinal role played by Concept and Feature is called Name,
	RoleConceptName                         varchar(64) NOT NULL,
	-- RoleRef is where RoleSequence in Ordinal position includes Role and Role is where FactType has Ordinal role played by Concept and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	RoleConceptVocabularyName               varchar(64) NULL,
	-- maybe RoleRef has leading-Adjective,
	LeadingAdjective                        varchar(64) NULL,
	-- maybe RoleRef has trailing-Adjective,
	TrailingAdjective                       varchar(64) NULL,
	PRIMARY KEY(RoleSequenceId, Ordinal),
	FOREIGN KEY (RoleFactTypeId, RoleOrdinal, RoleConceptName, RoleConceptVocabularyName) REFERENCES Role (FactTypeId, Ordinal, ConceptName, ConceptVocabularyName)
)
GO

CREATE TABLE RoleSequence (
	-- RoleSequence has RoleSequenceId,
	RoleSequenceId                          int IDENTITY NOT NULL,
	PRIMARY KEY(RoleSequenceId)
)
GO

CREATE TABLE RoleValue (
	-- Population includes RoleValue and Population has Name,
	PopulationName                          varchar(64) NOT NULL,
	-- Population includes RoleValue and maybe Vocabulary includes Population and Vocabulary is called Name,
	PopulationVocabularyName                varchar(64) NULL,
	-- RoleValue fulfils Fact and Fact has FactId,
	FactId                                  int NOT NULL,
	-- Instance plays RoleValue and Instance has InstanceId,
	InstanceId                              int NOT NULL,
	-- RoleValue is of Role and Role is where FactType has Ordinal role played by Concept and FactType has FactTypeId,
	RoleFactTypeId                          int NOT NULL,
	-- RoleValue is of Role and Role is where FactType has Ordinal role played by Concept,
	RoleOrdinal                             int NOT NULL,
	-- RoleValue is of Role and Role is where FactType has Ordinal role played by Concept and Feature is called Name,
	RoleConceptName                         varchar(64) NOT NULL,
	-- RoleValue is of Role and Role is where FactType has Ordinal role played by Concept and maybe Feature belongs to Vocabulary and Vocabulary is called Name,
	RoleConceptVocabularyName               varchar(64) NULL,
	PRIMARY KEY(InstanceId, FactId),
	FOREIGN KEY (FactId) REFERENCES Fact (FactId),
	FOREIGN KEY (InstanceId) REFERENCES Instance (InstanceId),
	FOREIGN KEY (RoleFactTypeId, RoleOrdinal, RoleConceptName, RoleConceptVocabularyName) REFERENCES Role (FactTypeId, Ordinal, ConceptName, ConceptVocabularyName)
)
GO

CREATE TABLE SetComparisonRoles (
	-- SetComparisonRoles is where SetComparisonConstraint covers RoleSequence and Constraint has ConstraintId,
	SetComparisonConstraintId               int NOT NULL,
	-- SetComparisonRoles is where SetComparisonConstraint covers RoleSequence and RoleSequence has RoleSequenceId,
	RoleSequenceId                          int NOT NULL,
	PRIMARY KEY(SetComparisonConstraintId, RoleSequenceId),
	FOREIGN KEY (SetComparisonConstraintId) REFERENCES [Constraint] (ConstraintId),
	FOREIGN KEY (RoleSequenceId) REFERENCES RoleSequence (RoleSequenceId)
)
GO

CREATE TABLE Unit (
	-- Unit has UnitId,
	UnitId                                  int IDENTITY NOT NULL,
	-- maybe Unit has Coefficient and Coefficient is precise,
	CoefficientIsPrecise                    bit NULL,
	-- maybe Unit has Coefficient and Coefficient has Numerator,
	CoefficientNumerator                    decimal NULL,
	-- maybe Unit has Coefficient and Coefficient has Denominator,
	CoefficientDenominator                  int NULL,
	-- Name is of Unit,
	Name                                    varchar(64) NOT NULL,
	-- Unit is fundamental,
	IsFundamental                           bit NOT NULL,
	PRIMARY KEY(UnitId)
)
GO

CREATE TABLE ValueRestriction (
	-- ValueRestriction has ValueRestrictionId,
	ValueRestrictionId                      int IDENTITY NOT NULL,
	PRIMARY KEY(ValueRestrictionId)
)
GO

ALTER TABLE AllowedRange
	ADD FOREIGN KEY (ValueRestrictionId) REFERENCES ValueRestriction (ValueRestrictionId)
GO

ALTER TABLE [Constraint]
	ADD FOREIGN KEY (RingConstraintRoleFactTypeId, RingConstraintRoleOrdinal, RingConstraintRoleConceptName, RingConstraintRoleConceptVocabularyName) REFERENCES Role (FactTypeId, Ordinal, ConceptName, ConceptVocabularyName)
GO

ALTER TABLE [Constraint]
	ADD FOREIGN KEY (RingConstraintOtherRoleFactTypeId, RingConstraintOtherRoleOrdinal, RingConstraintOtherRoleConceptName, RingConstraintOtherRoleConceptVocabularyName) REFERENCES Role (FactTypeId, Ordinal, ConceptName, ConceptVocabularyName)
GO

ALTER TABLE [Constraint]
	ADD FOREIGN KEY (PresenceConstraintRoleSequenceId) REFERENCES RoleSequence (RoleSequenceId)
GO

ALTER TABLE [Constraint]
	ADD FOREIGN KEY (SubsetConstraintSupersetRoleSequenceId) REFERENCES RoleSequence (RoleSequenceId)
GO

ALTER TABLE [Constraint]
	ADD FOREIGN KEY (SubsetConstraintSubsetRoleSequenceId) REFERENCES RoleSequence (RoleSequenceId)
GO

ALTER TABLE Correspondence
	ADD FOREIGN KEY (ImportedFeatureName, ImportedFeatureVocabularyName) REFERENCES Feature (Name, VocabularyName)
GO

ALTER TABLE Correspondence
	ADD FOREIGN KEY (LocalFeatureName, LocalFeatureVocabularyName) REFERENCES Feature (Name, VocabularyName)
GO

ALTER TABLE Derivation
	ADD FOREIGN KEY (DerivedUnitId) REFERENCES Unit (UnitId)
GO

ALTER TABLE Derivation
	ADD FOREIGN KEY (BaseUnitId) REFERENCES Unit (UnitId)
GO

ALTER TABLE Fact
	ADD FOREIGN KEY (FactTypeId) REFERENCES FactType (FactTypeId)
GO

ALTER TABLE FactType
	ADD FOREIGN KEY (TypeInheritanceSubtypeName, TypeInheritanceSubtypeVocabularyName) REFERENCES Feature (Name, VocabularyName)
GO

ALTER TABLE FactType
	ADD FOREIGN KEY (TypeInheritanceSupertypeName, TypeInheritanceSupertypeVocabularyName) REFERENCES Feature (Name, VocabularyName)
GO

ALTER TABLE FactType
	ADD FOREIGN KEY (EntityTypeName, EntityTypeVocabularyName) REFERENCES Feature (Name, VocabularyName)
GO

ALTER TABLE Feature
	ADD FOREIGN KEY (ValueTypeValueRestrictionId) REFERENCES ValueRestriction (ValueRestrictionId)
GO

ALTER TABLE Feature
	ADD FOREIGN KEY (ValueTypeUnitId) REFERENCES Unit (UnitId)
GO

ALTER TABLE JoinPath
	ADD FOREIGN KEY (RoleRefRoleSequenceId, RoleRefOrdinal) REFERENCES RoleRef (RoleSequenceId, Ordinal)
GO

ALTER TABLE JoinPath
	ADD FOREIGN KEY (InputRoleFactTypeId, InputRoleOrdinal, InputRoleConceptName, InputRoleConceptVocabularyName) REFERENCES Role (FactTypeId, Ordinal, ConceptName, ConceptVocabularyName)
GO

ALTER TABLE JoinPath
	ADD FOREIGN KEY (OutputRoleFactTypeId, OutputRoleOrdinal, OutputRoleConceptName, OutputRoleConceptVocabularyName) REFERENCES Role (FactTypeId, Ordinal, ConceptName, ConceptVocabularyName)
GO

ALTER TABLE Reading
	ADD FOREIGN KEY (RoleSequenceId) REFERENCES RoleSequence (RoleSequenceId)
GO

ALTER TABLE Role
	ADD FOREIGN KEY (RoleValueRestrictionId) REFERENCES ValueRestriction (ValueRestrictionId)
GO

ALTER TABLE RoleRef
	ADD FOREIGN KEY (RoleSequenceId) REFERENCES RoleSequence (RoleSequenceId)
GO

