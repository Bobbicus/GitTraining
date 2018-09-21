   Function Get-Nsg
        {
        Param ([int]$NSGType) 
                $NSGType
                #Retrieve the Nic Name
                $nic = $vm.NetworkProfile.NetworkInterfaces.id | Split-Path -Leaf
                #Retrieve the effective NSGs for the given Nic
                $nsg = Get-AzureRmEffectiveNetworkSecurityGroup -NetworkInterfaceName $nic -ResourceGroupName $VMRG 


                #Get NSG Name
                $NsgName = $nsg.NetworkSecurityGroup.Id | Split-Path -Leaf

                #Get Subnet Name
                $subnet = $nsg.Association.Subnet.Id | Split-Path -Leaf -ErrorAction SilentlyContinue
                if ($subnet -eq $null)
                {
                    $subnet = "No rule at subnet level."
                }

                if ($NSGType -eq 1)
                {
                    #Filter out Default Rules and only Outbound rules first
                    $NsgResults = $nsg.EffectiveSecurityRules | Where-Object {$_.Name -notlike "defaultSecurityRules*"} 
                }
                elseif($NSGType -eq 2)
                {
                    #Filter out Default Rules and only Outbound rules first
                    $NsgResults = $nsg.EffectiveSecurityRules | Where-Object {$_.Name -notlike "defaultSecurityRules*" -and $_.Direction -eq 'Inbound'} 

                }
                elseif($NSGType -eq 3)
                {
                    #Filter out Default Rules and only Outbound rules first
                    $NsgResults = $nsg.EffectiveSecurityRules | Where-Object {$_.Name -notlike "defaultSecurityRules*" -and $_.Direction -eq 'Outbound'} 
                }

                return $NsgResults
        }